# python/test_entropy.py
from entropy_consumer import EntropyDiceConsumer
import unittest

class TestEntropy(unittest.TestCase):
    def test_mapping(self):
        consumer = EntropyDiceConsumer("0x...")
        random_data = b'\x00' * 32 + b'sample_randomness'
        roll = consumer.map_random_number(random_data, 1, 6)
        self.assertTrue(1 <= roll <= 6)

if __name__ == "__main__":
    unittest.main()
