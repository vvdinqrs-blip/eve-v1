# python/entropy_consumer.py
from web3 import Web3
import json

class EntropyDiceConsumer:
    """Pyth Network Entropy Consumer for Python."""
    
    def __init__(self, provider_address):
        self.provider_address = Web3.to_checksum_address(provider_address)
        self.web3 = Web3(Web3.HTTPProvider("https://polygon-rpc.com"))
        self.dice_rolls = []
    
    def map_random_number(self, data: bytes, min_val: int, max_val: int) -> int:
        """Map Pyth random number to desired range."""
        if len(data) < 32:
            data = b'\x00' * (32 - len(data)) + data
        
        random_uint = int.from_bytes(data[:32], 'big')
        range_val = max_val - min_val + 1
        return min_val + (random_uint % range_val)
    
    def request_entropy(self, receiver_contract):
        """Request entropy from Pyth Network via smart contract."""
        pass
    
    def process_callback(self, sequence_number, provider, random_bytes32):
        """Process callback and return dice roll."""
        roll = self.map_random_number(random_bytes32, 1, 6)
        self.dice_rolls.append(roll)
        return roll
    
    def get_dice_stats(self):
        """Get statistics from rolls."""
        if not self.dice_rolls:
            return {}
        return {
            "average": sum(self.dice_rolls) / len(self.dice_rolls),
            "max": max(self.dice_rolls),
            "min": min(self.dice_rolls)
        }
