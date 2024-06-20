import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["button"];

  connect() {
    window.addEventListener("load", () => {
      this.noMetamask();
    });
  }

  async login() {
    this.noMetamask();

    const chainid = await this.requestChainId();
    console.log(chainid);

    try {
      const address = await this.requestAccounts();
      
      if (address) {
        const loginStatus = await this.requestLogin(address);
        const data = await loginStatus.json();

        if (data.data === "reload") {
          location.reload();
          console.log(" reload ");
        } else {
          alert(data.data);
        }
      }
    } catch (error) {
      console.log(error);
    } finally {
      console.log(".. finally ..");
    }
  }

  async requestLogin(address) {
    return fetch("/metamask/eth/" + address);
  }
  
  async requestAccounts() {
    const accounts = await ethereum.request({ method: "eth_requestAccounts" });
    console.log(accounts);
    return accounts[0];
  }

  async requestChainId() {
    return await ethereum.request({method: "eth_chainId"});
  }

  noMetamask(){
    if (typeof window.ethereum !== "undefined") {
      console.log("... metamask installed ...");
      // buttonEthConnect.addEventListener("click", () => {
      //   this.login();
      // });
    } else {
      const buttonEthConnect = document.getElementById("metabtn");
      buttonEthConnect.disabled = true;
      buttonEthConnect.style.filter = "grayscale(100%)";
      this.showAlert();
      throw new Error('Your have no metamask!!!');
    }
  }

  showAlert() {
    const alertPlaceholder = document.getElementById('liveAlertPlaceholder');

    // 定义 appendAlert 函数
    const appendAlert = (message, type) => {
      const wrapper = document.createElement('div');
      wrapper.innerHTML = [
        `<div class="bg_gradient text-light alert alert-${type} alert-dismissible" role="alert">`,
        `   <div>${message}</div>`,
        '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>',
        '</div>'
      ].join('');

      alertPlaceholder.append(wrapper);
    };

    // 立即显示 Alert 消息
    appendAlert('ZAAT needs to install metamask to continue.', 'success');
  }
  
}