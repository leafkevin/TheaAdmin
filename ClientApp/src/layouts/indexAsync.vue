<!-- 💥 这里是异步加载 LayoutComponents -->
<template>
  <suspense>
    <template #default>
      <component :is="LayoutComponents[layout]" />
    </template>
    <template #fallback>
      <Loading />
    </template>
  </suspense>
  <ThemeDrawer />
</template>

<script setup lang="ts" name="layoutAsync">
  import { computed, defineAsyncComponent, type Component } from "vue";
  import { useGlobalStore } from "@/stores/global";
  import Loading from "@/components/Loading/index.vue";
  import ThemeDrawer from "./components/ThemeDrawer/index.vue";
  import { LayoutType } from "@/stores/types";

  const LayoutComponents: Record<LayoutType, Component> = {
    vertical: defineAsyncComponent(() => import("./LayoutVertical/index.vue")),
    classic: defineAsyncComponent(() => import("./LayoutClassic/index.vue")),
    transverse: defineAsyncComponent(() => import("./LayoutTransverse/index.vue")),
    columns: defineAsyncComponent(() => import("./LayoutColumns/index.vue"))
  };

  const globalStore = useGlobalStore();
  const layout = computed(() => globalStore.layout);
</script>

<style scoped lang="scss">
  .layout {
    min-width: 600px;
  }
</style>
