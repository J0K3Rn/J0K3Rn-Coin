import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";

actor Token {

    let owner : Principal = Principal.fromText("ibz72-jjt27-vqhyu-dy2nk-xuadx-7vt55-irspc-koi3w-aetpw-dkv55-oae");
    let totalSupply : Nat = 1000000000; // 9 billion
    let symbol : Text = "DJKR";

    private stable var balanceEntries: [(Principal, Nat)] = []; // To store entries while upgrading
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    if (balances.size() < 1){
        balances.put(owner, totalSupply);
    };

    public query func balanceOf(who: Principal) : async Nat {

        let balance : Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared(msg) func payOut() : async Text {
        if (balances.get(msg.caller) == null){
            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Already Claimed";
        };

    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        let fromBalance = await balanceOf(msg.caller);
        if(fromBalance > amount){
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await balanceOf(to); 
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);

            return "Success";
        } else {
            return "Insufficient Funds";
        }
    };

    // Save balances to a stable variable
    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    // Restore balances from stable variable
    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1){
            balances.put(owner, totalSupply);
        };
    };

}