import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  get_model() {
    const paramValue = this.data.get('url')
    console.log(paramValue)
    const uri = "/order/order_" + paramValue + "/textured_OTS.schematic"
    console.log(uri)
    // window.open(uri, "_blank")
    // 创建一个隐藏的 a 标签并模拟点击它来下载文件
    const a = document.createElement('a');
    a.href = uri;
    a.download = this.file_name(); // 设置下载文件的默认名称
    a.style.display = 'none';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  file_name(){
    const now = new Date();
    return (
      now.getFullYear() +
      ("0" + (now.getMonth() + 1)).slice(-2) +
      ("0" + now.getDate()).slice(-2) +
      ("0" + now.getHours().toString()).slice(-2) +
      ("0" + now.getMinutes().toString()).slice(-2) +
      ("0" + now.getSeconds().toString()).slice(-2) +
      ".schematic"
    );
  }
}