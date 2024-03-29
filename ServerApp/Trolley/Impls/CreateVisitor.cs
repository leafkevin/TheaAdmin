﻿using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace Trolley;

public class CreateVisitor : SqlVisitor, ICreateVisitor
{
    private static ConcurrentDictionary<int, Action<StringBuilder, object>> headSqlSetterCache = new();
    private static ConcurrentDictionary<int, object> valuesSqlParametersCache = new();
    private static ConcurrentDictionary<int, object> multiValuesSqlParametersCache = new();

    protected List<CommandSegment> deferredSegments = new();

    public List<string> OnlyFieldNames { get; set; }
    public List<string> IgnoreFieldNames { get; set; }
    public List<FieldsSegment> InsertFields { get; set; } = new();
    public bool IsBulk { get; set; }
    public bool IsReturnIdentity { get; set; }
    public bool IsUseCte { get; set; }

    public CreateVisitor(IOrmProvider ormProvider, IEntityMapProvider mapProvider, bool isParameterized = false, char tableAsStart = 'a', string parameterPrefix = "p")
    {
        this.OrmProvider = ormProvider;
        this.MapProvider = mapProvider;
        this.IsParameterized = isParameterized;
        this.TableAsStart = tableAsStart;
        this.ParameterPrefix = parameterPrefix;
    }
    public virtual void Initialize(Type entityType, bool isMultiple = false, bool isFirst = true)
    {
        if (!isMultiple)
        {
            this.Tables = new();
            this.TableAliases = new();
            this.Tables.Add(new TableSegment
            {
                EntityType = entityType,
                AliasName = "a",
                Mapper = this.MapProvider.GetEntityMap(entityType)
            });
        }
        if (!isFirst) this.Clear();
    }
    public virtual string BuildCommand(IDbCommand command, bool isReturnIdentity)
    {
        string sql = null;
        this.IsReturnIdentity = isReturnIdentity;
        this.DbParameters = command.Parameters;
        foreach (var deferredSegment in this.deferredSegments)
        {
            switch (deferredSegment.Type)
            {
                case "WithBy":
                    this.VisitWithBy(deferredSegment.Value);
                    break;
                case "WithByField":
                    this.VisitWithByField(deferredSegment.Value);
                    break;
                case "WithBulk":
                    this.IsBulk = true;
                    continue;
            }
        }
        if (this.IsBulk)
            sql = this.BuildMultiBulkSql(command);
        if (sql == null) sql = this.BuildSql();
        return sql;
    }
    public virtual MultipleCommand CreateMultipleCommand()
    {
        return new MultipleCommand
        {
            CommandType = MultipleCommandType.Insert,
            EntityType = this.Tables[0].EntityType,
            Body = this.deferredSegments,
            Tables = this.Tables,
            IgnoreFieldNames = this.IgnoreFieldNames,
            OnlyFieldNames = this.OnlyFieldNames,
            RefQueries = this.RefQueries,
            IsNeedTableAlias = this.IsNeedTableAlias
        };
    }
    public virtual void BuildMultiCommand(IDbCommand command, StringBuilder sqlBuilder, MultipleCommand multiCommand, int commandIndex)
    {
        this.IsMultiple = true;
        this.CommandIndex = commandIndex;
        this.deferredSegments = multiCommand.Body as List<CommandSegment>;
        this.Tables = multiCommand.Tables;
        this.IgnoreFieldNames = multiCommand.IgnoreFieldNames;
        this.OnlyFieldNames = multiCommand.OnlyFieldNames;
        this.RefQueries = multiCommand.RefQueries;
        this.IsNeedTableAlias = multiCommand.IsNeedTableAlias;
        if (sqlBuilder.Length > 0) sqlBuilder.Append(';');
        sqlBuilder.Append(this.BuildCommand(command, false));
    }
    public virtual string BuildSql()
    {
        var tableName = this.OrmProvider.GetTableName(this.Tables[0].Mapper.TableName);
        var fieldsBuilder = new StringBuilder($"INSERT INTO {tableName} (");

        var valuesBuilder = new StringBuilder();
        valuesBuilder.Append(" VALUES(");
        for (int i = 0; i < this.InsertFields.Count; i++)
        {
            var insertField = this.InsertFields[i];
            if (i > 0)
            {
                fieldsBuilder.Append(',');
                valuesBuilder.Append(',');
            }
            fieldsBuilder.Append(insertField.Fields);
            valuesBuilder.Append(insertField.Values);
        }
        fieldsBuilder.Append(')');
        valuesBuilder.Append(')');

        if (this.IsReturnIdentity)
        {
            if (!this.Tables[0].Mapper.IsAutoIncrement)
                throw new Exception($"实体{this.Tables[0].Mapper.EntityType.FullName}表未配置自增长字段，无法返回Identity值");
            valuesBuilder.Append(this.OrmProvider.GetIdentitySql(this.Tables[0].EntityType));
        }
        fieldsBuilder.Append(valuesBuilder);
        valuesBuilder.Clear();
        return fieldsBuilder.ToString();
    }
    public virtual void WithBy(object insertObj)
    {
        this.deferredSegments.Add(new CommandSegment
        {
            Type = "WithBy",
            Value = insertObj
        });
    }
    public virtual void WithByField(Expression fieldSelector, object fieldValue)
    {
        this.deferredSegments.Add(new CommandSegment
        {
            Type = "WithByField",
            Value = (fieldSelector, fieldValue)
        });
    }
    public virtual void WithBulk(object insertObjs, int bulkCount)
    {
        this.IsBulk = true;
        this.deferredSegments.Add(new CommandSegment
        {
            Type = "WithBulk",
            Value = (insertObjs as IEnumerable, bulkCount)
        });
    }
    public virtual void IgnoreFields(string[] fieldNames)
    {
        this.IgnoreFieldNames ??= new();
        this.IgnoreFieldNames.AddRange(fieldNames);
    }
    public virtual void IgnoreFields(Expression fieldsSelector)
        => this.IgnoreFieldNames = this.VisitFields(fieldsSelector);
    public virtual void OnlyFields(string[] fieldNames)
    {
        this.OnlyFieldNames ??= new();
        this.OnlyFieldNames.AddRange(fieldNames);
    }
    public virtual void OnlyFields(Expression fieldsSelector)
        => this.OnlyFieldNames = this.VisitFields(fieldsSelector);
    public virtual string BuildMultiBulkSql(IDbCommand command)
    {
        //多语句查询才会走到此分支
        if (!this.IsMultiple) return null;

        int index = 0;
        var builder = new StringBuilder();
        (var insertObjs, var bulkCount) = ((IEnumerable, int))this.deferredSegments[0].Value;
        var entityType = this.Tables[0].EntityType;
        //多语句执行，一次性不分批次
        (var headSqlSetter, var commandInitializer) = RepositoryHelper.BuildCreateMultiSqlParameters(this.OrmProvider, this.MapProvider, entityType, insertObjs, this.OnlyFieldNames, this.IgnoreFieldNames, true);
        foreach (var insertObj in insertObjs)
        {
            if (index > 0) builder.Append(',');
            commandInitializer.Invoke(command.Parameters, this.OrmProvider, builder, insertObj, $"_m{this.CommandIndex}");
            index++;
        }
        return builder.ToString();
    }
    public virtual (IEnumerable, int, Action<StringBuilder>, Action<StringBuilder, object, string>) BuildWithBulk(IDbCommand command)
    {
        this.DbParameters = command.Parameters;
        var entityType = this.Tables[0].EntityType;
        (var insertObjs, var bulkCount) = ((IEnumerable, int))this.deferredSegments[0].Value;
        if (this.deferredSegments.Count > 1)
        {
            object insertObj = null;
            foreach (var entity in insertObjs)
            {
                insertObj = entity;
                break;
            }
            var insertObjType = insertObjs.GetType();
            var entityMapper = this.Tables[0].Mapper;

            var cacheKey = RepositoryHelper.BuildInsertHashKey(this.OrmProvider, this.MapProvider, entityType, insertObjType, this.OnlyFieldNames, this.IgnoreFieldNames);
            var headSqlBulkSetter = headSqlSetterCache.GetOrAdd(cacheKey, f => RepositoryHelper.BuildCreateHeadSqlPart(
                 this.OrmProvider, this.MapProvider, entityType, insertObjType, this.OnlyFieldNames, this.IgnoreFieldNames));

            for (int i = 1; i < this.deferredSegments.Count; i++)
            {
                var deferredSegment = this.deferredSegments[i];
                switch (deferredSegment.Type)
                {
                    case "WithBy":
                        this.VisitWithBy(deferredSegment.Value);
                        break;
                    case "WithByField":
                        this.VisitWithByField(deferredSegment.Value);
                        break;
                    default: throw new NotSupportedException("批量插入后，只支持WithBy/IgnoreFields/OnlyFields操作");
                }
            }
            var fixedDbParameters = this.DbParameters.Cast<IDbDataParameter>().ToList();
            Action<StringBuilder> headSqlSetter = (builder) =>
            {
                builder.Append($"INSERT INTO {this.OrmProvider.GetFieldName(entityMapper.TableName)} (");
                for (int i = 0; i < this.InsertFields.Count; i++)
                {
                    var insertField = this.InsertFields[i];
                    if (i > 0) builder.Append(',');
                    builder.Append(insertField.Fields);
                }
                headSqlBulkSetter.Invoke(builder, insertObj);
                builder.Append(") VALUES ");
                if (fixedDbParameters.Count > 0)
                    fixedDbParameters.ForEach(f => this.DbParameters.Add(f));
            };
            var valuesPartSqlParameters = multiValuesSqlParametersCache.GetOrAdd(cacheKey, f => RepositoryHelper.BuildCreateValuesPartSqlParametes(
                 this.OrmProvider, this.MapProvider, entityType, insertObjType, this.OnlyFieldNames, this.IgnoreFieldNames, true));
            var typedValuesPartSqlParameters = valuesPartSqlParameters as Action<IDataParameterCollection, IOrmProvider, StringBuilder, object, string>;

            this.DbParameters.Clear();
            Action<StringBuilder, object, string> commandInitializer = null;
            commandInitializer = (builder, insertObj, suffix) =>
            {
                builder.Append('(');
                for (int i = 0; i < this.InsertFields.Count; i++)
                {
                    var insertField = this.InsertFields[i];
                    if (i > 0) builder.Append(',');
                    builder.Append(insertField.Values);
                }
                fixedDbParameters.ForEach(f => this.DbParameters.Add(f));
                typedValuesPartSqlParameters.Invoke(this.DbParameters, this.OrmProvider, builder, insertObj, suffix);
                builder.Append(')');
            };
            return (insertObjs, bulkCount, headSqlSetter, commandInitializer);
        }
        else
        {
            (var headSqlSetter, var typedCommandInitializer) = RepositoryHelper.BuildCreateMultiSqlParameters(this.OrmProvider, this.MapProvider, entityType, insertObjs, this.OnlyFieldNames, this.IgnoreFieldNames, true);
            Action<StringBuilder, object, string> commandInitializer = null;
            commandInitializer = (builder, insertObj, suffix) => typedCommandInitializer.Invoke(this.DbParameters, this.OrmProvider, builder, insertObj, suffix);
            return (insertObjs, bulkCount, headSqlSetter, commandInitializer);
        }
    }
    public virtual void VisitWithBy(object insertObj)
    {
        var entityType = this.Tables[0].EntityType;
        var insertObjType = insertObj.GetType();
        var cacheKey = RepositoryHelper.BuildInsertHashKey(this.OrmProvider, this.MapProvider, entityType, insertObjType, this.OnlyFieldNames, this.IgnoreFieldNames);
        var headSqlSetter = headSqlSetterCache.GetOrAdd(cacheKey, f =>
            RepositoryHelper.BuildCreateHeadSqlPart(this.OrmProvider, this.MapProvider, entityType, insertObjType, this.OnlyFieldNames, this.IgnoreFieldNames));
        var commandInitializerCache = this.IsMultiple ? multiValuesSqlParametersCache : valuesSqlParametersCache;
        var commandInitializer = commandInitializerCache.GetOrAdd(cacheKey, f =>
            RepositoryHelper.BuildCreateValuesPartSqlParametes(this.OrmProvider, this.MapProvider, entityType, insertObjType, this.OnlyFieldNames, this.IgnoreFieldNames, this.IsMultiple));
        var fieldsBuilder = new StringBuilder();
        headSqlSetter.Invoke(fieldsBuilder, insertObj);
        var valuesBuilder = new StringBuilder();
        if (this.IsMultiple)
        {
            var typedCommandInitializer = commandInitializer as Action<IDataParameterCollection, IOrmProvider, StringBuilder, object, string>;
            typedCommandInitializer.Invoke(this.DbParameters, this.OrmProvider, valuesBuilder, insertObj, $"_m{this.CommandIndex}");
        }
        else
        {
            var typedCommandInitializer = commandInitializer as Action<IDataParameterCollection, IOrmProvider, StringBuilder, object>;
            typedCommandInitializer.Invoke(this.DbParameters, this.OrmProvider, valuesBuilder, insertObj);
        }
        this.InsertFields.Add(new FieldsSegment
        {
            Fields = fieldsBuilder.ToString(),
            Values = valuesBuilder.ToString()
        });
    }
    public virtual void VisitWithByField(object deferredSegmentValue)
    {
        (var fieldSelector, var fieldValue) = ((Expression, object))deferredSegmentValue;
        var lambdaExpr = fieldSelector as LambdaExpression;
        var memberExpr = lambdaExpr.Body as MemberExpression;
        var entityMapper = this.Tables[0].Mapper;
        var memberMapper = entityMapper.GetMemberMap(memberExpr.Member.Name);
        var parameterName = this.OrmProvider.ParameterPrefix + memberMapper.MemberName;
        if (this.IsMultiple) parameterName += $"_m{this.CommandIndex}";
        var dbFieldValue = memberMapper.TypeHandler.ToFieldValue(this.OrmProvider, memberMapper.UnderlyingType, fieldValue);
        this.DbParameters.Add(this.OrmProvider.CreateParameter(parameterName, memberMapper.NativeDbType, dbFieldValue));
        this.InsertFields.Add(new FieldsSegment
        {
            Fields = this.OrmProvider.GetFieldName(memberMapper.FieldName),
            Values = parameterName
        });
    }
    public virtual List<string> VisitFields(Expression fieldsSelector)
    {
        var lambdaExpr = fieldsSelector as LambdaExpression;
        var entityMapper = this.Tables[0].Mapper;
        this.TableAliases.Clear();
        this.TableAliases.Add(lambdaExpr.Parameters[0].Name, this.Tables[0]);
        var fieldNames = new List<string>();
        switch (lambdaExpr.Body.NodeType)
        {
            case ExpressionType.New:
                var newExpr = lambdaExpr.Body as NewExpression;
                for (int i = 0; i < newExpr.Arguments.Count; i++)
                {
                    var memberInfo = newExpr.Members[i];
                    if (!entityMapper.TryGetMemberMap(memberInfo.Name, out var memberMapper))
                        continue;
                    if (newExpr.Arguments[i] is not MemberExpression memberExpr)
                        throw new NotSupportedException($"不支持的表达式访问，只支持MemberAccess访问，Path:{newExpr.Arguments[i]}");
                    fieldNames.Add(memberMapper.MemberName);
                }
                break;
            case ExpressionType.MemberInit:
                var memberInitExpr = lambdaExpr.Body as MemberInitExpression;
                for (int i = 0; i < memberInitExpr.Bindings.Count; i++)
                {
                    var memberAssignment = memberInitExpr.Bindings[i] as MemberAssignment;
                    if (!entityMapper.TryGetMemberMap(memberAssignment.Member.Name, out var memberMapper))
                        continue;
                    if (memberAssignment.Expression is not MemberExpression memberExpr)
                        throw new NotSupportedException($"不支持的表达式访问，只支持MemberAccess访问，Path:{memberAssignment.Expression}");
                    fieldNames.Add(memberMapper.MemberName);
                }
                break;
        }
        if (fieldNames.Count > 0)
            return fieldNames;
        return null;
    }
    public virtual void Clear()
    {
        this.Tables?.Clear();
        this.TableAliases?.Clear();
        this.ReaderFields?.Clear();
        this.WhereSql = null;
        this.TableAsStart = 'a';
        this.IsNeedTableAlias = false;
        this.deferredSegments.Clear();
        this.InsertFields.Clear();
    }
    public override void Dispose()
    {
        base.Dispose();
        this.deferredSegments = null;
        this.InsertFields = null;
        this.OnlyFieldNames = null;
        this.IgnoreFieldNames = null;
    }
}
