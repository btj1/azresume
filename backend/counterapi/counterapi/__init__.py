import logging
import azure.functions as func
##
def main(req: func.HttpRequest, readcounter: func.DocumentList, writecounter: func.Out[func.Document]) -> func.HttpResponse:
    logging.info('Website was visited.')

    if not readcounter:
        logging.warning("Counter not found, please check backend config")
        return func.HttpResponse("No counter",status_code=500)
    
    else:

        logging.info("Found Counter, processing visit")
        readcounter[0]['count'] = readcounter[0]['count'] + 1
        writecounter.set(readcounter[0])
        return func.HttpResponse(str(readcounter[0]['count']),status_code=200)
