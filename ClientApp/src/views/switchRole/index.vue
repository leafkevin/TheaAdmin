<template>
  <div class="main-box">
    <ProTable ref="proTable" title="我的角色列表" highlight-current-row :columns="columns" :request-api="queryList">
      <!-- 表格 header 按钮 -->
      <template #tableHeader>
        <el-text class="mx-1">我的角色列表</el-text>
      </template>
      <!-- 表格操作 -->
      <template #operation="scope">
        <el-button type="primary" link :icon="Check" @click="switchRole(scope.row)"> 查看</el-button>
      </template>
    </ProTable>
  </div>
</template>
<script setup lang="ts">
  import { ref, reactive, onMounted } from "vue";
  import { IRoleState } from "./types";
  import { IColumnProps } from "@/components/ProTable/interface/index";
  import { ILoginResponse, getMyRoles, switchRole as switchRoleApi } from "@/api/account";
  import { useRouter } from "vue-router";
  import { getTimeState } from "@/utils";
  import { useUserStore } from "@/stores/account";
  import { useTabPageStore } from "@/stores/tabPages";
  import { useKeepAliveStore } from "@/stores/keepAlive";
  import { ElNotification } from "element-plus";
  import { Check } from "@element-plus/icons-vue";
  import { useMenuStore } from "@/stores/menu";

  const router = useRouter();
  const userStore = useUserStore();
  const menuStore = useMenuStore();
  const dataList = ref<IRoleState[]>([]);

  // 表格配置项
  const columns = reactive<IColumnProps<IRoleState>[]>([
    { prop: "roleId", label: "角色ID", width: 120 },
    { prop: "roleName", label: "角色名称", width: 120 },
    { prop: "description", label: "描述" },
    { prop: "operation", label: "选择", width: 330 }
  ]);

  const switchRole = async (row: IRoleState) => {
    const response = await switchRoleApi({ roleId: row.roleId });
    if (!response.isSuccess) {
      ElNotification({
        title: "切换角色失败",
        message: `切换角色失败，${response.message}，code:${response.code}`,
        type: "error"
      });
    }
    const loginResponse = response.data as ILoginResponse;
    userStore.setState(loginResponse);
    menuStore.setState(loginResponse.menuRoutes);

    //需要转到选择角色页面 code=9
    if (response.code > 0) {
      router.push({ name: "SwitchRole", replace: true });
      return;
    }

    //返回了菜单和路由，就更新路由
    if (menuStore.hasMenuRoutes) {
      menuStore.loadAsyncMenuRoutes();

      const keepAliveStore = useKeepAliveStore();
      const tabPageStore = useTabPageStore();
      keepAliveStore.setKeepAliveNames([]);
      tabPageStore.setTabPages([]);
    }

    //跳转到首页
    router.push({ name: "Home" });
    ElNotification({
      title: getTimeState(),
      message: `登录成功，欢迎${userStore.userName}`,
      type: "success",
      duration: 3000
    });
  };
  const queryList = async () => {
    const response = await getMyRoles();
    if (!response.isSuccess) {
      ElNotification({
        title: "获取角色失败",
        message: `获取角色失败，${response.message}，code:${response.code}`,
        type: "error"
      });
    }
    dataList.value = response.data as IRoleState[];
  };
  onMounted(async () => {
    await queryList();
  });
</script>

<style></style>
