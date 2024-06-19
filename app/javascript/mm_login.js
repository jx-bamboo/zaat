// ...... 登录注册 start ......
var buttonEthConnect = document.querySelector("button.eth_connect");
console.log(buttonEthConnect)

if (typeof window.ethereum !== "undefined") {
  console.log("... have metamask ...")
  buttonEthConnect.addEventListener("click", async () => {
    console.log("... Click the button ...")
    //buttonEthConnect.disabled = true;
    try {
      console.log(' ... into try ...')
      const address = await requestAccounts();
      console.log(address)
      if(address) {
        console.log(" ... a address ... ")
        const login_status = await requestLogin(address);
        const data = await login_status.json();
        console.log(data)

        if(data.data == "reload"){
          location.reload();
          console.log(" reload ")
        } else {
          alert(data.data)
        }
      }
    } catch (error) {
        console.log(error);
    } finally {
      console.log(".. finally ..")
      buttonEthConnect.disabled = false;
    }
  });
} else {
  console.log('... no metamask ...')
  buttonEthConnect.disabled = true;
  buttonEthConnect.style.filter = "grayscale(100%)";
}

async function requestLogin(address) {
  console.log(" .. into requestLogin ..");
  return fetch("/metamask/eth/" + address);
}

async function requestAccounts() {
  console.log('.... into request account ....')
  const accounts = await ethereum.request({ method: "eth_accounts" });
  console.log(accounts)
  return accounts[0];
}
// ...... 登录注册 end ......

// 
async function requestBalance(address) {
  const balance = await ethereum.request({method: "eth_getBalance", params: [address]});
  return parseInt(balance, 16) / Math.pow(10, 18);
}

async function requestChainId() {
  console.log("... 进入chainid ...")
  const chainid = await ethereum.request({method: "eth_chainId"});
  return chainid;
}

async function checkPolygonNet() {
  const chainid = await requestChainId();
  if (chainid === '0x89' || chainid === '0x13881') {
    console.log('用户已连接到 Polygon 网络，执行下一步操作 ..')
  } else {
    console.log('用户 no Polygon 网络xxxxxxx')
    try {
      console.log("in to try");
      await ethereum.request({
          method: 'wallet_addEthereumChain',
          params: [{
              chainId: '0x89',
              chainName: 'Polygon Mainnet',
              nativeCurrency: {
                name: "MATIC",
                symbol: "MATIC",
                decimals: 18,
              },
              rpcUrls: ['https://rpc-mainnet.maticvigil.com/'],
              blockExplorerUrls: ['https://polygonscan.com/']
          }]
      });

      console.log('Switch to the Polygon network')
      await ethereum.request({ method: "wallet_switchEthereumChain", params: [{ chainId: "0x89" }] });
        // 提示用户已成功添加 Polygon 网络
      console.log('用户已连接到 Polygon 网络 .........................')
    } catch (error) {
      console.error("error: ", error);
        // 处理错误情况
    }
  }
}