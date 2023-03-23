import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { createRoot } from 'react-dom/client';
import { AuthClient } from "@dfinity/auth-client";

const init = async () => { 
  const domNode = document.getElementById("root")
  const root = createRoot(domNode);
  
  //ReactDOM.render(<App />, document.getElementById("root"));
  //root.render(<App />); // Reenable if want to test locally without AuthClient

  const authClient = await AuthClient.create();

  if (await authClient.isAuthenticated()){
    handleAuthenticated(authClient);
  } else {
    await authClient.login({
      identityProvider: "https://identity.ic0.app/#authorize",
      onSuccess: () => {
        handleAuthenticated(authClient);
      }
    });
  }


}

async function handleAuthenticated(authClient){
  const identity = await authClient.getIdentity();
  const userPrincipal = identity._principal.toString();
  root.render(<App loggedInPrincipal={userPrincipal}/>); 
}

init();


