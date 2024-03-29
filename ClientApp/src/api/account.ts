import { IMenuRoute } from "@/stores/types";
import { http } from "./http";

export interface ILoginResponse {
  userId: string;
  userName: string;
  accessToken: string;
  refreshToken: string;
  expires: number;
  roles: string;
  menuRoutes: IMenuRoute[];
}

export const login = (parameters: object) => {
  return http.post("/account/login", parameters);
};
export const refreshToken = (parameters: object) => {
  return http.post("/account/refreshToken", parameters);
};
export const resetPassword = (parameters: object) => {
  return http.post("/profile/resetPassword", parameters);
};
export const getMyRoles = () => {
  return http.get("/profile/getMyRoles", {});
};
export const getMyRoutes = () => {
  return http.get("/profile/getMyRoutes", {});
};
export const switchRole = (parameters: { roleId: string }) => {
  return http.post("/profile/switchRole", parameters);
};
