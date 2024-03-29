import { http } from "./http";

export interface IMemberState {
  memberId?: string;
  memberName: string;
  mobile: string;
  gender: number;
  balance: number | string;
  description: string;
}
export const queryPage = (parameters: object) => {
  return http.post("/member/queryPage", parameters);
};
export const getMember = (id: string) => {
  return http.get(`/member/detail?id=${id}`);
};
export const createMember = (parameters: object) => {
  return http.post("/member/create", parameters);
};
export const importMembers = (parameters: FormData) => {
  return http.upload("/member/import", parameters);
};
export const modifyMember = (parameters: object) => {
  return http.post("/member/modify", parameters);
};
export const deleteMember = (parameters: object) => {
  return http.post("/member/delete", parameters);
};
export const batchDeleteMembers = (parameters: object) => {
  return http.post("/member/batchDelete", parameters);
};
export const exportMembers = (parameters: object) => {
  return http.download("/member/export", parameters);
};
export const downloadTemplate = () => {
  return http.download("/excelTemplate/download", { fileName: "MemberImportTemplate.xlsx" });
};
