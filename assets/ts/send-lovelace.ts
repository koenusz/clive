
import { getWallet, getBalance, bech32FromHex, getTransactionBuilder, getTransactionUnpentOutputs } from './wallet'
import * as SerializationLib from '@emurgo/cardano-serialization-lib-browser'
import { Buffer } from 'buffer';

export async function sendLovelace(walletName: string, addr: string, amount: string) {
    try {
        console.log(addr, amount);

        const wallet = await getWallet(walletName);

        // Retrieve the change address from the wallet
        const hexaddress = await wallet.getChangeAddress();
        const changeAddress = SerializationLib.Address.from_bytes(Buffer.from(hexaddress, 'hex'));
        const sendToAddress = SerializationLib.Address.from_bech32(addr)

        console.log("Change address:", bech32FromHex(hexaddress));
        console.log("Change address2:", changeAddress.to_bech32());
        console.log("Wallet balance:", await getBalance(wallet));

        // Get unspent transaction outputs (UTXOs) that cover the specified amount
        const transactionUnspentOutputs = await getTransactionUnpentOutputs(wallet);

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

        txBuilder.set_ttl_bignum(SerializationLib.BigNum.from_str("69458906"))

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

