import unittest
import azure.functions as func
import counterapi
from counterapi import main

# class to mock the CosmosDB outbound binding behaviour
class cosmosmock (func.Out) :
    def set(self, val: func.Document):
        value = val
        
    def get():
        return value

class test_counterapi(unittest.TestCase):

    def test_counter(self):
        
# Prepare the input parameters for the counterapi 
        req = None
        counterdata = func.Document.from_dict({"count": 2})
        readcounter = func.DocumentList([counterdata])
        writecounter = cosmosmock()
    
 # Call the function.

        resp = main(req,readcounter,writecounter)
        self.assertEqual(
            int(resp.get_body()),3
        )


        # Check the output.
  #      self.assertEqual(
   #         resp.get_body(), 
    ##        'Hello, Test!',
    #    )