import { ChatResponse } from '../models/chat'
import http from '@ohos.net.http';
const req = http.createHttp()

export async function requestMessage(content: string) {
  try {
    const res = await req.request(`https://api.sizhi.com/chat?appid=6f43a27b49c5407aaa0a36acbe335cc4&userid=1&spoken=${encodeURIComponent(content)}`)
    const result =JSON.parse(res.result as string) as ChatResponse
    return result
  } catch (error) {
    return Promise.reject(error)
  }
}