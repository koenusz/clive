
// import { NetworkType, Wallet } from '@cardano-foundation/cardano-connect-with-wallet-core';

import { getWallet, getBalance, getBalanceByName, bech32FromHex, getTransactionBuilder, getTransactionUnpentOutputs } from './wallet'
import * as SerializationLib from '@emurgo/cardano-serialization-lib-browser'
// import { decode as decodeCbor } from 'cborg';
import { Buffer } from 'buffer';

// export function subscribeBalance(sub: (value: number) => void) {
//     // Wallet.accountBalanceObserver.subscribe(sub)
// }

// export async function connectToWallet(name: string, network: NetworkType): Promise<number> {
//     // Wallet.connectToWallet(name, network)
//     // return Wallet.accountBalanceObserver.value
// }

// export function disconnect() {
//     // Wallet.disconnect();
// }

export async function balance(): Promise<number> {

    return getBalanceByName("nami")
}

// export function sign(message: string, onSignMessage?: (signature: string, key: string | undefined) => void, onSignError?: (error: Error) => void, limitNetwork?: NetworkType): Promise<void> {
// return Wallet.signMessage(message, onSignMessage, onSignError, limitNetwork);
// }

// export async function sendLovelace(addr: string, amount: string) {

//     console.log(addr, amount)

//     const wallet = await getWallet("nami")
//     const hexaddress = await wallet.getChangeAddress();
//     const changeAddress = SerializationLib.Address.from_bytes(Buffer.from(hexaddress, 'hex'));


//     console.log("Change address:", bech32FromHex(hexaddress));
//     console.log("Wallet balance:", await getBalance(wallet));

//     const transactionUnspentOutputs = await getTransactionUnpentOutputs(wallet, amount)


//     // Create and send a transaction
//     const txBuilder: SerializationLib.TransactionBuilder = getTransactionBuilder();


//     txBuilder.add_inputs_from(transactionUnspentOutputs, SerializationLib.CoinSelectionStrategyCIP2.RandomImprove)

//     //add the outputs
//     const output = SerializationLib.TransactionOutput.new(
//         SerializationLib.Address.from_bech32(addr),
//         SerializationLib.Value.new(SerializationLib.BigNum.from_str(amount))
//     )
//     txBuilder.add_output(output)

//     //Add change needs to be the last thing done before building, because it calculates the fees
//     txBuilder.add_change_if_needed(changeAddress)

//     const txBody = txBuilder.build();
//     const txBodyHex = Buffer.from(txBody.to_bytes()).toString('hex');
//     const witnessSetHex = await wallet.signTx(txBodyHex);


//     const witnessSet = SerializationLib.TransactionWitnessSet.from_bytes(Buffer.from(witnessSetHex, 'hex'))
//     const signedTx = SerializationLib.Transaction.new(txBody, witnessSet);
//     const signedTxHex = Buffer.from(signedTx.to_bytes()).toString('hex');

//     const txHash = await wallet.submitTx(signedTxHex);
//     console.log(txHash);
// }

export async function sendLovelace(addr: string, amount: string) {
    try {
        console.log(addr, amount);

        const wallet = await getWallet("nami");

        // Retrieve the change address from the wallet
        const hexaddress = await wallet.getChangeAddress();
        const changeAddress = SerializationLib.Address.from_bytes(Buffer.from(hexaddress, 'hex'));
        const sendToAddress = SerializationLib.Address.from_bech32(addr)

        console.log("Change address:", bech32FromHex(hexaddress));
        console.log("Change address2:", changeAddress.to_bech32());
        console.log("Wallet balance:", await getBalance(wallet));

        // Get unspent transaction outputs (UTXOs) that cover the specified amount
        const transactionUnspentOutputs = await getTransactionUnpentOutputs(wallet);

        // // Deserialize UTXOs from CBOR format
        // const transactionUnspentOutputs = SerializationLib.TransactionUnspentOutputs.new();
        // for (const cborUtxo of utxosCbor) {
        //     const utxo = SerializationLib.TransactionUnspentOutput.from_bytes(Buffer.from(cborUtxo, 'hex'));
        //     transactionUnspentOutputs.add(utxo);
        // }

        // Initialize the transaction builder
        const txBuilder: SerializationLib.TransactionBuilder = getTransactionBuilder();

        // Add inputs from the UTXOs using the CIP2 coin selection strategy
        txBuilder.add_inputs_from(transactionUnspentOutputs, SerializationLib.CoinSelectionStrategyCIP2.RandomImprove);

        // Add the output (destination address and amount)
        const output = SerializationLib.TransactionOutput.new(
            sendToAddress,
            SerializationLib.Value.new(SerializationLib.BigNum.from_str(amount))
        );

        output.address()
        txBuilder.add_output(output);

        txBuilder.set_ttl_bignum(SerializationLib.BigNum.from_str("64980934"))

        // Add change (must be the last step before building)
        txBuilder.add_change_if_needed(changeAddress);


        // Build the transaction
        const txBody = txBuilder.build();
        console.log("transaction", txBody.to_json());


        // Sign the transaction

        const transactionWitnessSet = SerializationLib.TransactionWitnessSet.new();
        const tx = SerializationLib.Transaction.new(
            txBody,
            SerializationLib.TransactionWitnessSet.from_bytes(transactionWitnessSet.to_bytes())
        )

        const txHex = Buffer.from(tx.to_bytes()).toString('hex');

        const witnessSetHex = await wallet.signTx(txHex);
        const witnessSet = SerializationLib.TransactionWitnessSet.from_bytes(Buffer.from(witnessSetHex, 'hex'));

        // Create the signed transaction
        const signedTx = SerializationLib.Transaction.new(txBody, witnessSet);
        const signedTxHex = Buffer.from(signedTx.to_bytes()).toString('hex');

        // Submit the transaction
        const txHash = await wallet.submitTx(signedTxHex);
        console.log("Transaction submitted. TxHash:", txHash);

        return txHash;
    } catch (error) {
        console.error("Error in sendLovelace function:", error);
        throw error;
    }
}

