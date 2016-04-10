<?php

ini_set('soap.wsdl_cache_enabled', WSDL_CACHE_NONE);

$vendorPathString = dirname(__FILE__) . '/vendor';
$vendorPath = realpath($vendorPathString);

if (!$vendorPathString || !file_exists($vendorPath)) {
    die("where is $vendorPathString?\n");
}

unset($vendorPath);
unset($vendorPathString);

$autoloader = require_once 'vendor/autoload.php';

if (!class_exists('Zend\Loader\AutoloaderFactory')) {
    die("where is auto loader?\n");
}

require_once("ArrayOfTypeSequence.php");

class StationBoard
{
    /** @var ServiceItem[]/service */
    public $trainServices;

    /** @var string[]/message */
    public $nrccMessages;

    /** @var string */
    public $crs;


    /** @var string */
    public $locationName;

    /** @var string */
    public $generatedAt;

    public function __construct() {
        $this->generatedAt = "" . time(); //TODO: this is probably not the right format
        $this->crs = "KGX";
        $this->locationName = "London Kings Cross";
        $this->trainServices = Array(new ServiceItem());
        $this->nrccMessages = Array("<P>" . ServiceItem::explanation() . "</P>");
    }
}

class ServiceItem
{

    /** @var string */
    public $serviceID;

    /** @var string */
    public $isCircularRoute;

    /** @var string */
    public $platform;

    /** @var ServiceLocation[]/location */
    public $destination;

    /** @var string */
    public $std;

    /** @var string */
    public $etd;

    /** @var ServiceLocation[]/location */
    public $origin;

    public static function explanation() {
        return "This isn't my kind of humour, but I put it in just in case it's your kind of humour";
    }

    public function __construct() {
        $this->serviceID = "testid";
        $this->isCircularRoute = 0; //TODO: this is not tested or used in example
        $this->platform = "9 3/4";
        $this->destination = Array(new ServiceLocation("Hogwarts", "H1H"));
        $this->origin = Array(new ServiceLocation("Kings Cross", "KGX"));
        $this->std = "11:00";
        $this->etd = "On time";
    }
}

class ServiceLocation {
    /** @var string */
    public $locationName;

    /** @var string */
    public $crs;

    public function __construct($locationName, $crs) {
        $this->locationName = $locationName;
        $this->crs = $crs;
    }
}

class MockNREService {

    /**
     * GetDepartureBoard
     *
     * @param integer $numRows
     * @param string $crs
     * @param string $filterCrs
     * @param string $FilterType
     * @param integer $timeOffset
     * @param integer $timeWindow
     * @return StationBoard
     */
    public function GetDepartureBoard($numRows, $crs, $filterCrs, $FilterType, $timeOffset, $timeWindow) {
        //the demo server only recognised kings cross - all other codes are unknown
        if ($crs != "KGX") throw new SOAPFault("Invalid crs code supplied", 500);
        $result = new StationBoard();
        return $result;
    }
}

function getWsdl() {
    $autodiscover = new Zend\Soap\AutoDiscover(new ArrayOfTypeSequence());
    $autodiscover->setClass('MockNREService');
    if (isset($_SERVER['HTTPS'])) throw new Exception("oops - we didn't plan for https");
    $autodiscover->setUri('http://'.$_SERVER['HTTP_HOST']);
    $autodiscovoredWsdl = $autodiscover->toXml();
    return str_replace("MockNREServicePort", "LDBServiceSoap", $autodiscovoredWsdl);
}

Class TemporaryWsdlFile
{
    public function __construct()
    {
        $this->path = tempnam(0, "temporaryWsdlFile");
        file_put_contents($this->path, getWsdl());
    }

    public function uri() {
        return "file://{$this->path}";
    }

    public function __destruct() {
        unlink($this->path);
    }
}

if(isset($_GET['wsdl'])) {
    header('Content-Type: text/xml');
    echo getWsdl();
} else {
    //don't pass in the public wsdl uri - we might not be using a
    //server that can handle simulataneous connections (webrick, php dev server)
    if (!isPost() || !tokenIsCorrect()) {
        header('Content-Type: text/html');
        http_response_code(401);
        echo file_get_contents(dirname(__FILE__) . "/wrong-token.html");
    } else if (!isTextXml()) {
        header('Content-Type: text/html');
        http_response_code(415);
        echo "bad media type";
    } else {
        $temporaryWsdlFile = new TemporaryWsdlFile();
        $soap = new Zend\Soap\Server($temporaryWsdlFile->uri(), Array("soap_version" => SOAP_1_1));
        $soap->setClass('MockNREService');
        $soap->handle();
    }
}

function isPost() {
    return $_SERVER['REQUEST_METHOD'] == "POST";
}

function isTextXml() {
    return strpos($_SERVER["HTTP_CONTENT_TYPE"], 'text/xml') !== false;
}

function tokenIsCorrect() {
    //this is good enough for what we doing
    //but probably not good enough for an actual soap server
    return strpos(getPayload(), 'FAKE-API-KEY') !== false;
}

function getPayload() {
    return file_get_contents('php://input');
}