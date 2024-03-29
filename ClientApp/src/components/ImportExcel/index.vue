<template>
  <el-dialog v-model="dialogVisible" :title="importParameters.title" :destroy-on-close="true" width="580px" draggable>
    <el-form class="drawer-multiColumn-form" label-width="100px">
      <el-form-item label="模板下载 :" class="el-dialog_body-margin_top">
        <el-button type="primary" :icon="Download" @click="downloadTemp"> 点击下载 </el-button>
      </el-form-item>
      <el-form-item label="文件上传 :">
        <el-upload
          action="#"
          class="upload"
          :drag="true"
          :limit="excelLimit"
          :multiple="true"
          :show-file-list="true"
          :http-request="uploadExcel"
          :before-upload="beforeExcelUpload"
          :on-exceed="handleExceed"
          :on-success="excelUploadSuccess"
          :on-error="excelUploadError"
          :accept="importParameters.fileType!.join(',')">
          <slot name="empty">
            <el-icon class="el-icon--upload">
              <upload-filled />
            </el-icon>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
          </slot>
          <template #tip>
            <slot name="tip">
              <div class="el-upload__tip">请上传 .xls , .xlsx 标准格式文件，文件最大为 {{ importParameters.fileSize }}M</div>
            </slot>
          </template>
        </el-upload>
      </el-form-item>
      <el-form-item label="注意 :">
        <el-text type="warning"> {{ importParameters.skipContent }} </el-text>
      </el-form-item>
    </el-form>
  </el-dialog>
</template>

<script setup lang="ts" name="ImportExcel">
  import { ref } from "vue";
  import { useDownload } from "@/hooks/useDownload";
  import { Download } from "@element-plus/icons-vue";
  import { ElNotification, UploadRequestOptions, UploadRawFile } from "element-plus";

  export interface ExcelParameterProps {
    title: string; // 标题
    templateName: string; //下载模板标题
    fileSize?: number; // 上传文件的大小
    fileType?: File.ExcelMimeType[]; // 上传文件的类型
    skipContent: string; // 存在数据跳过描述文本
    tempApi?: (params: any) => Promise<any>; // 下载模板的Api
    importApi?: (params: any) => Promise<any>; // 批量导入的Api
    getTableList?: () => void; // 获取表格数据的Api
  }

  // 最大文件上传数
  const excelLimit = ref(1);
  // dialog状态
  const dialogVisible = ref(false);
  // 父组件传过来的参数
  const importParameters = ref<ExcelParameterProps>({
    title: "批量导入",
    templateName: "批量导入模板",
    fileSize: 5,
    fileType: ["application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
    skipContent: "导入过程中，已存在的数据将会跳过，不会导入！"
  });

  // 接收父组件参数
  const acceptParameters = (params: ExcelParameterProps) => {
    importParameters.value = { ...importParameters.value, ...params };
    dialogVisible.value = true;
  };

  // Excel 导入模板下载
  const downloadTemp = () => {
    if (!importParameters.value.tempApi) return;
    useDownload(importParameters.value.tempApi, importParameters.value.title, {}, false);
  };

  // 文件上传
  const uploadExcel = async (param: UploadRequestOptions) => {
    let excelFormData = new FormData();
    excelFormData.append("file", param.file);
    await importParameters.value.importApi!(excelFormData);
    importParameters.value.getTableList && importParameters.value.getTableList();
    dialogVisible.value = false;
  };

  /**
   * @description 文件上传之前判断
   * @param file 上传的文件
   * */
  const beforeExcelUpload = (file: UploadRawFile) => {
    const isExcel = importParameters.value.fileType!.includes(file.type as File.ExcelMimeType);
    const fileSize = file.size / 1024 / 1024 < importParameters.value.fileSize!;
    if (!isExcel)
      ElNotification({
        title: "温馨提示",
        message: "上传文件只能是 xls / xlsx 格式！",
        type: "warning"
      });
    if (!fileSize)
      setTimeout(() => {
        ElNotification({
          title: "温馨提示",
          message: `上传文件大小不能超过 ${importParameters.value.fileSize}MB！`,
          type: "warning"
        });
      }, 0);
    return isExcel && fileSize;
  };

  // 文件数超出提示
  const handleExceed = () => {
    ElNotification({
      title: "温馨提示",
      message: "最多只能上传一个文件！",
      type: "warning"
    });
  };

  // 上传错误提示
  const excelUploadError = () => {
    ElNotification({
      title: "温馨提示",
      message: `${importParameters.value.title}失败，请您重新上传！`,
      type: "error"
    });
  };

  // 上传成功提示
  const excelUploadSuccess = () => {
    ElNotification({
      title: "温馨提示",
      message: `${importParameters.value.title}成功！`,
      type: "success"
    });
  };

  defineExpose({
    acceptParameters
  });
</script>
<style lang="scss" scoped>
  @import "./index.scss";
</style>
