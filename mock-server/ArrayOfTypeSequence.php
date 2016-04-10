<?php



use Zend\Soap\Wsdl;

class ArrayOfTypeSequence extends Zend\Soap\Wsdl\ComplexTypeStrategy\ArrayOfTypeSequence
{
    /**
     * Add an unbounded ArrayOfType based on the xsd:sequence syntax with a special array name if
     * type[]/arrayName is detected in return value doc comment.
     *
     * Otherwise just send it on to the normal type[]
     *
     * @throws Exception when you try to do this type[][]/arrayName since it only works for one level
     * @throws Exception when it tries to
     *
     * @param  string $type
     * @return string tns:xsd-type
     */
    public function addComplexType($type)
    {
        if (sizeof($this->componentsOfType($type)) != 2) { //no special array - use 'item'
            return parent::addComplexType($type);
        }

        list($complexTypeInParentFormat, $arrayName) = $this->componentsOfType($type);

        if ($this->_getNestedCount($type) != 1) {
            throw new Exception("to use the special format, we need exactly one set of [], but got {$this->_getNestedCount($type)}");
        }

        $singularType = $this->_getSingularType($complexTypeInParentFormat);

        $childType = $this->getContext()->getType($singularType); //this also creates the singular type if it does not exist

        $complexType = $this->_getTypeBasedOnNestingLevel($singularType, 1) . "Called" . ucfirst($arrayName);

        //instead of replacing _addSequenceType, let's just call it as normal and then do some surgery on the dom after
        $this->_addSequenceType($complexType, $childType, $type);
        $this->_replaceArrayNameInSequence($complexType, $arrayName);

        return $complexType;
    }

    /**
     * From a nested definition like type[]/arrayName, get the type and array name
     *
     * @param  string $type
     * @return array
     */
    function componentsOfType($type) {
        return explode("/", $type);
    }


    protected function _replaceArrayNameInSequence($complexType, $arrayName) {
        $this->_getInnerElementOfSequenceDef($complexType)->setAttribute('name', $arrayName);
    }

    protected function _getInnerElementOfSequenceDef($complexType) {
        $elementTags = $this->_getComplexTypeElement($complexType)->getElementsByTagNameNS(Wsdl::XSD_NS_URI, 'element');
        if (sizeof($elementTags) != 1) throw new Exception("we are expecting 1 element for $complexType but got " . sizeof($elementTags));
        return $elementTags[0];
    }

    protected function _getComplexTypeElement($complexType) {
        foreach($this->getContext()->toDomDocument()->getElementsByTagNameNS(Wsdl::XSD_NS_URI, 'complexType') as $possibleElement) {
            if (Wsdl::TYPES_NS . ":" . $possibleElement->getAttribute('name') == $complexType) {
                return $possibleElement;
            }
        }
        throw new Exception("can't find :complexType name item type $complexType");
    }

}
