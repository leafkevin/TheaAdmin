/*
 Navicat Premium Data Transfer

 Source Server         : mariadb
 Source Server Type    : MariaDB
 Source Server Version : 110202 (11.2.2-MariaDB-1:11.2.2+maria~ubu2204)
 Source Host           : localhost:3306
 Source Schema         : salon

 Target Server Type    : MariaDB
 Target Server Version : 110202 (11.2.2-MariaDB-1:11.2.2+maria~ubu2204)
 File Encoding         : 65001

 Date: 14/03/2024 09:58:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for mos_balance
-- ----------------------------
DROP TABLE IF EXISTS `mos_balance`;
CREATE TABLE `mos_balance`  (
  `MemberId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会员ID',
  `Balance` double(10, 2) NULL DEFAULT NULL COMMENT '余额',
  `ExpiryDate` datetime NULL DEFAULT NULL COMMENT '有效期',
  `ExpectedTimes` int(11) NULL DEFAULT NULL COMMENT '预计使用次数',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`MemberId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员余额表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mos_balance
-- ----------------------------

-- ----------------------------
-- Table structure for mos_deposit
-- ----------------------------
DROP TABLE IF EXISTS `mos_deposit`;
CREATE TABLE `mos_deposit`  (
  `DepositId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '充值ID',
  `MemberId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会员ID',
  `Amount` double(10, 2) NOT NULL COMMENT '充值金额',
  `Bonus` double(10, 2) NULL DEFAULT NULL COMMENT '赠送金额',
  `BeginBalance` double(10, 2) NULL DEFAULT NULL COMMENT '充值前余额',
  `EndBalance` double(10, 2) NULL DEFAULT NULL COMMENT '充值后余额',
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`DepositId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '充值表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mos_deposit
-- ----------------------------

-- ----------------------------
-- Table structure for mos_member
-- ----------------------------
DROP TABLE IF EXISTS `mos_member`;
CREATE TABLE `mos_member`  (
  `MemberId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会员ID',
  `MemberName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `Mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `Gender` tinyint(4) NULL DEFAULT NULL COMMENT '性别',
  `Balance` double(10, 2) NULL DEFAULT NULL COMMENT '余额',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`MemberId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mos_member
-- ----------------------------
INSERT INTO `mos_member` VALUES ('65dd407f8d0be6d9a48932e1', 'kevin', '18516063052', '888', 1, 4444.00, 2, '1', '2024-02-24 07:33:25', '1', '2024-03-14 08:30:59');
INSERT INTO `mos_member` VALUES ('65dd407f8d0be6d9a48932e2', 'cindy', '18516063025', '2222', 2, 300.00, 2, '1', '2024-02-24 07:34:16', '1', '2024-03-14 08:30:57');
INSERT INTO `mos_member` VALUES ('65dd407f8d0be6d9a48932f0', 'xiyuan', '18516521234', '234234', 1, 2000.00, 2, '1', '2024-02-27 09:53:03', '1', '2024-03-14 08:30:50');
INSERT INTO `mos_member` VALUES ('65e2dbaea71eb0f22e2fc588', '安刚', '18516063052', '描述信息', 1, 200.00, 1, '1', '2024-03-02 15:56:30', '1', '2024-03-02 15:56:30');
INSERT INTO `mos_member` VALUES ('65f23a042c5b27887029d1bc', 'kevin', '18516063052', '1111', 1, 1240.00, 1, '1', '2024-03-14 07:43:00', '1', '2024-03-14 08:31:15');
INSERT INTO `mos_member` VALUES ('65f23ab92c5b27887029d1bd', 'cindy', '18516063025', '2222', 2, 300.00, 1, '1', '2024-03-14 07:46:01', '1', '2024-03-14 07:46:01');
INSERT INTO `mos_member` VALUES ('65f23bdd2c5b27887029d1be', 'xiyuan', '18516521234', '234234', 2, 2000.00, 1, '1', '2024-03-14 07:50:53', '1', '2024-03-14 08:31:30');

-- ----------------------------
-- Table structure for mos_order
-- ----------------------------
DROP TABLE IF EXISTS `mos_order`;
CREATE TABLE `mos_order`  (
  `OrderId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单ID',
  `MemberId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会员ID',
  `StylistId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '设计师ID',
  `IsAppointed` tinyint(1) NULL DEFAULT 0 COMMENT '是否指定理发师',
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `Amount` double(10, 2) NULL DEFAULT NULL COMMENT '消费余额',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`OrderId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mos_order
-- ----------------------------

-- ----------------------------
-- Table structure for mos_stylist
-- ----------------------------
DROP TABLE IF EXISTS `mos_stylist`;
CREATE TABLE `mos_stylist`  (
  `UserId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '设计师ID',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `Account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账号',
  `Mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `Email` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮件地址',
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `AvatarUrl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像地址',
  `Password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `Salt` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '盐',
  `LockoutEnd` datetime NULL DEFAULT NULL COMMENT '解锁时间',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`UserId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '设计师表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mos_stylist
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `MenuId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单ID',
  `MenuName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `RouteName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路由名称',
  `RouteUrl` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由地址',
  `RedirectUrl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '重定向URL',
  `Description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `ParentId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上级菜单ID',
  `RouteType` tinyint(4) NULL DEFAULT NULL COMMENT '路由类型',
  `Icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `IsStatic` tinyint(1) NULL DEFAULT 0 COMMENT '是否静态路由',
  `Sequence` int(11) NULL DEFAULT NULL COMMENT '序号',
  `Status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`MenuId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '管理员角色根菜单', 'AdminRoot', '', '', '', '', 0, '', 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('11', '首页', 'Home', '/home', '/home/index', '', '', 2, 'HomeFilled', 1, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('12', '系统管理', 'SystemMgt', '/systemMgt', '/user/index', '', '1', 1, 'Avatar', 0, 9, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('121', '用户管理', 'UserList', '/user', '', '', '12', 2, 'UserFilled', 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('122', '角色管理', 'RoleList', '/role', '', '管理角色', '12', 2, 'UserFilled', 0, 2, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('123', '菜单管理', 'MenuList', '/menu', '', '', '12', 2, 'UserFilled', 0, 3, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('124', '授权管理', 'AuthList', '/auth', '', '给用户分配角色，并分配操作菜单', '12', 2, 'UserFilled', 0, 4, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('13', '会员管理', 'MemberMgt', '/memberMgt', '/member/index', '', '1', 1, 'Avatar', 0, 2, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('131', '会员列表', 'MemberList', '/member', '', '', '13', 2, 'UserFilled', 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('132', '充值管理', 'DepositList', '/deposit', '', '', '13', 2, 'UserFilled', 0, 2, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('2', '店员角色根菜单', 'EmpRoot', '', '', '', '', 0, '', 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('21', '会员管理', 'memberMgt', '/memberMgt', '/member/index', '', '2', 1, 'Avatar', 0, 2, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('211', '会员列表', 'memberList', '/member', '', '', '22', 2, 'UserFilled', 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_menu` VALUES ('212', '充值管理', 'depositList', '/deposit', '', '', '22', 2, 'UserFilled', 0, 2, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');

-- ----------------------------
-- Table structure for sys_menu_page
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_page`;
CREATE TABLE `sys_menu_page`  (
  `MenuId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单ID',
  `RouteId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路由ID',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`MenuId`, `RouteId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单页面关联表，描述菜单与页面路由的关联关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu_page
-- ----------------------------
INSERT INTO `sys_menu_page` VALUES ('11', '1', '1', '2024-03-10 09:23:26');
INSERT INTO `sys_menu_page` VALUES ('11', '3', '1', '2024-03-10 09:49:32');
INSERT INTO `sys_menu_page` VALUES ('11', '4', '1', '2024-03-10 09:49:38');
INSERT INTO `sys_menu_page` VALUES ('11', '5', '1', '2024-03-10 09:49:44');
INSERT INTO `sys_menu_page` VALUES ('121', '11', '1', '2024-03-10 08:39:49');
INSERT INTO `sys_menu_page` VALUES ('121', '12', '1', '2024-03-10 09:29:58');
INSERT INTO `sys_menu_page` VALUES ('122', '13', '1', '2024-03-10 09:05:01');
INSERT INTO `sys_menu_page` VALUES ('122', '14', '1', '2024-03-10 09:30:48');
INSERT INTO `sys_menu_page` VALUES ('123', '15', '1', '2024-03-10 09:24:11');
INSERT INTO `sys_menu_page` VALUES ('123', '16', '1', '2024-03-10 09:31:19');
INSERT INTO `sys_menu_page` VALUES ('124', '17', '1', '2024-03-10 09:24:11');
INSERT INTO `sys_menu_page` VALUES ('124', '18', '1', '2024-03-10 09:31:53');
INSERT INTO `sys_menu_page` VALUES ('131', '31', '1', '2024-03-10 09:52:47');
INSERT INTO `sys_menu_page` VALUES ('131', '32', '1', '2024-03-10 09:52:54');
INSERT INTO `sys_menu_page` VALUES ('132', '41', '1', '2024-03-10 09:53:51');
INSERT INTO `sys_menu_page` VALUES ('132', '42', '1', '2024-03-10 09:54:14');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `RoleId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色ID',
  `RoleName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`RoleId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '管理员', NULL, 1, '1', '2024-03-10 07:33:56', '1', '2024-03-10 07:33:56');
INSERT INTO `sys_role` VALUES ('2', '普通店员', NULL, 1, '1', '2024-03-10 07:33:56', '1', '2024-03-10 07:33:56');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `RoleId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色ID',
  `MenuId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单ID',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`RoleId`, `MenuId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('1', '1', '1', '2024-03-05 13:06:31');
INSERT INTO `sys_role_menu` VALUES ('2', '2', '1', '2024-03-05 13:06:31');

-- ----------------------------
-- Table structure for sys_route
-- ----------------------------
DROP TABLE IF EXISTS `sys_route`;
CREATE TABLE `sys_route`  (
  `RouteId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路由ID',
  `RouteName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路由名称',
  `RouteTitle` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路由标题',
  `RouteUrl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路由地址',
  `Component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组件物理路径',
  `Description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `RedirectUrl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '重定向URL',
  `Icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `IsStatic` tinyint(1) NULL DEFAULT 0 COMMENT '是否静态路由',
  `IsHidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否需要隐藏',
  `IsLink` tinyint(1) NULL DEFAULT 0 COMMENT '是否外部连接',
  `IsFull` tinyint(1) NULL DEFAULT 0 COMMENT '是否全屏显示',
  `IsAffix` tinyint(1) NULL DEFAULT 0 COMMENT '是否固定标签页',
  `IsKeepAlive` tinyint(1) NULL DEFAULT 1 COMMENT '是否缓存',
  `Status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`RouteId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '页面路由表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_route
-- ----------------------------
INSERT INTO `sys_route` VALUES ('1', 'Home', '首页', '/home/index', '/home/index', NULL, NULL, 'UserFilled', 1, 0, 0, 0, 1, 0, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('11', 'UserList', '用户列表', '/user/index', '/user/index', NULL, NULL, 'UserFilled', 0, 0, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('12', 'UserEdit', '用户编辑', '/user/edit', '/user/form', NULL, NULL, 'UserFilled', 0, 1, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('13', 'RoleList', '角色列表', '/role/index', '/role/index', NULL, NULL, 'UserFilled', 0, 0, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('14', 'RoleEdit', '角色编辑', '/role/edit', '/role/edit', NULL, NULL, 'UserFilled', 0, 1, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('15', 'MenuList', '菜单列表', '/menu/index', '/menu/index', NULL, NULL, 'UserFilled', 0, 0, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('16', 'MenuEdit', '菜单编辑', '/menu/edit', '/menu/form', NULL, NULL, 'UserFilled', 0, 1, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('17', 'AuthList', '授权列表', '/auth/index', '/auth/index', NULL, NULL, 'UserFilled', 0, 0, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('18', 'AuthEdit', '用户授权', '/auth/form', '/auth/form', NULL, NULL, 'UserFilled', 0, 1, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('2', 'Login', '登录', '/login/index', '/login/index', NULL, NULL, 'UserFilled', 1, 0, 0, 0, 0, 0, 0, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('3', 'SwitchRole', '切换角色', '/switchRole/index', '/switchRole/index', NULL, NULL, 'UserFilled', 1, 0, 0, 0, 0, 1, 0, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('31', 'MemberList', '会员列表', '/member/index', '/member/index', NULL, NULL, 'UserFilled', 0, 0, 0, 0, 0, 0, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('32', 'MemberEdit', '会员编辑', '/member/edit', '/member/form', NULL, NULL, 'UserFilled', 0, 1, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('4', 'Profile', '个人信息', '/profile/index', '/profile/index', NULL, NULL, 'UserFilled', 1, 0, 0, 0, 0, 1, 0, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('41', 'DepositList', '充值列表', '/deposit/index', '/deposit/index', NULL, NULL, 'CreditCard', 0, 0, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('42', 'DepositEdit', '会员充值', '/deposit/edit', '/deposit/form', NULL, NULL, 'CreditCard', 0, 1, 0, 0, 0, 1, 1, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');
INSERT INTO `sys_route` VALUES ('5', 'ResetPwd', '重置密码', '/resetPwd/index', '/resetPwd/index', NULL, NULL, 'UserFilled', 1, 0, 0, 0, 0, 1, 0, '1', '2024-03-03 01:06:40', '1', '2024-03-03 01:06:40');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `UserId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `Account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号',
  `Mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `Email` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮件地址',
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `AvatarUrl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像地址',
  `Password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `Salt` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '盐',
  `LockoutEnd` datetime NULL DEFAULT NULL COMMENT '解锁时间',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `CreatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '创建日期',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`UserId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表,所有登陆系统的用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', 'kevin', 'leafkevin', '18516063052', NULL, NULL, NULL, 'AAAAAQAAJxAAAAAQQscVYn2S2q0JXirAF3EezrYMK8nN5qFoneujteplI7qS519HBApIwwa064LiCBrf', 'QscVYn2S2q0JXirAF3Eezg==', NULL, 1, '1', '2024-02-24 00:24:36', '1', '2024-02-24 00:24:36');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `UserId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
  `RoleId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色ID',
  `UpdatedBy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后更新人',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '最后更新日期',
  PRIMARY KEY (`UserId`, `RoleId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('1', '1', '1', '2024-03-05 13:06:18');

SET FOREIGN_KEY_CHECKS = 1;
