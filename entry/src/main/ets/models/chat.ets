export interface ChatResponse {
  status:number,
  message: string,
  data: ChatData
}
export interface ChatData {
  type: string,
  info: ChatInfo
  score: number,
  skill: string
}
export interface ChatInfo {
  text: string
}