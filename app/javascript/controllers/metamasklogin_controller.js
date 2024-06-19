import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["button"];

  connect() {
    const buttonEthConnect = document.getElementById("metabtn");
    
    if (typeof window.ethereum !== "undefined") {
      console.log("... metamask installed ...");
      buttonEthConnect.addEventListener("click", () => {
        this.login();
      });
    } else {
      console.log("... no metamask ...");
      buttonEthConnect.disabled = true;
      buttonEthConnect.style.filter = "grayscale(100%)";
    }
  }

  async login() {
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
      buttonEthConnect.disabled = false;
    }
  }

  async requestLogin(address) {
    return fetch("/metamask/eth/" + address);
  }
  
  async requestAccounts() {
    const accounts = await ethereum.request({ method: "eth_accounts" });
    console.log(accounts);
    return accounts[0];
  }
}