import React from "react";
import Header from "./Header";
import Faucet from "./Faucet";
import Balance from "./Balance";
import Transfer from "./Transfer";

function App(props) {

  return (
    <div id="screen">
      <Header />
      <Faucet userPrincipal={props.loggedInPrincipal}/>
      <Balance />
      <Transfer userPrincipal={props.loggedInPrincipal}/>
    </div>
  );
}

export default App;
