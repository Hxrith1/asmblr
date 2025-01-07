use solana_sdk::{
    signature::{Keypair, Signer}, // Explicitly import Signer
    transaction::VersionedTransaction,
    message::VersionedMessage,
};
use std::ffi::{CStr, CString};
use bs58;
use bincode;

#[no_mangle]
pub extern "C" fn sign_transaction(
    tx_data: *const u8,
    tx_len: usize,
    mint_private_key_base58: *const i8,
    creator_private_key_base58: *const i8,
) -> *mut i8 {
    // Convert raw pointers to slices safely
    let tx_slice = unsafe { std::slice::from_raw_parts(tx_data, tx_len) };

    // Convert Base58 private keys into strings
    let mint_private_key_str = unsafe {
        CStr::from_ptr(mint_private_key_base58)
            .to_str()
            .expect("Invalid Mint Private Key string")
    };
    let creator_private_key_str = unsafe {
        CStr::from_ptr(creator_private_key_base58)
            .to_str()
            .expect("Invalid Creator Private Key string")
    };

    // Decode Base58 private keys into raw bytes
    let mint_private_bytes = match bs58::decode(mint_private_key_str).into_vec() {
        Ok(bytes) => bytes,
        Err(_) => {
            eprintln!("Error: Invalid Base58 Mint Private Key");
            return CString::new("Error: Invalid Base58 Mint Private Key").unwrap().into_raw();
        }
    };

    let creator_private_bytes = match bs58::decode(creator_private_key_str).into_vec() {
        Ok(bytes) => bytes,
        Err(_) => {
            eprintln!("Error: Invalid Base58 Creator Private Key");
            return CString::new("Error: Invalid Base58 Creator Private Key").unwrap().into_raw();
        }
    };

    // Construct Keypair objects
    let mint_keypair = match Keypair::from_bytes(&mint_private_bytes) {
        Ok(keypair) => keypair,
        Err(_) => {
            eprintln!("Error creating Mint Keypair");
            return CString::new("Error: Invalid Mint Keypair").unwrap().into_raw();
        }
    };

    let creator_keypair = match Keypair::from_bytes(&creator_private_bytes) {
        Ok(keypair) => keypair,
        Err(_) => {
            eprintln!("Error creating Creator Keypair");
            return CString::new("Error: Invalid Creator Keypair").unwrap().into_raw();
        }
    };

    // Deserialize transaction
    let tx_result: Result<VersionedTransaction, _> = bincode::deserialize(tx_slice);
    let mut tx = match tx_result {
        Ok(transaction) => transaction,
        Err(_) => {
            eprintln!("Error deserializing transaction");
            return CString::new("Error: Invalid Transaction Data").unwrap().into_raw();
        }
    };

    // Extract and sign the message
    let message = match &tx.message {
        VersionedMessage::Legacy(_) => {
            eprintln!("Legacy transactions are not supported");
            return CString::new("Error: Legacy Transaction Not Supported").unwrap().into_raw();
        }
        VersionedMessage::V0(message) => message,
    };

    // Add signatures to the transaction
    tx.signatures.clear();
    tx.signatures.push(mint_keypair.sign_message(&message.serialize()));
    tx.signatures.push(creator_keypair.sign_message(&message.serialize()));

    // Serialize the signed transaction
    let serialized_tx = match bincode::serialize(&tx) {
        Ok(tx) => tx,
        Err(_) => {
            eprintln!("Error serializing signed transaction");
            return CString::new("Error: Failed to Serialize Transaction").unwrap().into_raw();
        }
    };

    // Encode the serialized transaction in Base58
    let base58_encoded_tx = bs58::encode(serialized_tx).into_string();

    let c_string = match CString::new(base58_encoded_tx) {
        Ok(cstr) => cstr,
        Err(_) => {
            eprintln!("Error creating CString");
            return CString::new("Error: CString Conversion Failed").unwrap().into_raw();
        }
    };

    c_string.into_raw()
}
