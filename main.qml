import QtQuick 2.5
import QtQuick.Window 2.0
import QtScxml 5.8

Window {
    id: window
    visible: true
    width: 280
    height: 493
    property string resultScreenText
    property int base:10
    property string baseText: "Decimal"
    property var processArray: []

    Rectangle {
        id: resultArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 70
        border.color: "white"
        border.width: 1
        color: "#46a2da"
        Text {
            id: resultText
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: resultScreenText;
            color: "white"
            font.pixelSize: window.height * 3 / 32
            font.family: "Open Sans Regular"
            fontSizeMode: Text.Fit
        }
        Text {
            id: baseTextId
            anchors.fill: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            text: baseText;
            color: "white"
            font.pixelSize: 12
            font.family: "Open Sans Regular"
            fontSizeMode: Text.Fit
        }
    }

    Rectangle{
        id:operator
        height: 142
        anchors.top: resultArea.bottom
        Repeater {
            id: operations
            model: ["÷", "*", "+", "-","Hex","Dec","Clr","="]
            Button {
                id:oper
                y: Math.floor(index /4) * height
                x: (index % 4) * width
                width: 70
                height: 70
                color: pressed ? "#5caa15" : "#80c342"
                text: modelData
                fontHeight: 0.4
                onClicked: {
                    if(text==="Clr"){
                        resultScreenText="";
                        processArray=[];
                    }else if(text==="Hex"){
                        base=16;
                        baseText="Hexadecimal";
                    }else if(text==="Dec"){
                        base=10;
                        baseText="Decimal";
                    }else if(text==="="){
                        if(base===16){
                            calculatHex()
                        }else{
                            calculatDecimal()
                        }
                    }else{
                        resultScreenText+=text;


                    }
                }
            }
        }
    }

    Rectangle{
        anchors.top:operator.bottom
        Repeater {

            id: digits
            model: ["F","E","D","C","B","A", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0"]
            Button {
                x: (index % 4) * width
                y: Math.floor(index / 4) * height
                width: 70
                height: 70
                color: pressed ? "#d6d6d6" : "#eeeeee"
                text: modelData
                onClicked: {
                    resultScreenText+=text;
                }
            }
        }
    }
    function calculatHex(){

        var expression = resultScreenText;
        var copy = expression;

        expression = expression.replace(/[0-9A-FA]+/g, "#");
        var numbers = copy.split(/[^0-9A-FA\.]+/);
        var operators = expression.split("#").filter(function(n){return n});
        var i=1;
        var j=0;

        var result;
        result=parseInt(numbers[0],16);
        while(i<numbers.length && j<operators.length){
            if(operators[j]==='+'){
                result=result+parseInt(numbers[i],16);
            }else if(operators[j]==="-"){
                result=result-parseInt(numbers[i],16);
            }else if(operators[j]==="*"){
                result=result*parseInt(numbers[i],16);
            }else if(operators[j]==="÷"){
                result=result/parseInt(numbers[i],16);
            }

            i++;
            j++;
        }
        resultScreenText=result.toString(16).toString(16).toUpperCase();
        processArray=[];



    }

    function calculatDecimal(){
        var expression = resultScreenText;
        var copy = expression;

        expression = expression.replace(/[0-9A-F]+/g, "#");
        var numbers = copy.split(/[^0-9A-F\.]+/);
        var operators = expression.split("#").filter(function(n){return n});
        var i=1;
        var j=0;
        var result;

        if(isNaN(numbers[0])){
            result=parseInt(numbers[0],16);
        }else{
            result=parseInt(numbers[0]);
        }
        while(i<numbers.length && j<operators.length){
            if(isNaN(numbers[i])){
                numbers[i]=parseInt(numbers[i],16);
            }else{
                numbers[i]=parseInt(numbers[i]);
            }

            if(operators[j]==='+'){
                result=result+numbers[i]
            }else if(operators[j]==="-"){
                result=result-numbers[i]
            }else if(operators[j]==="*"){
                result=result*numbers[i]
            }else if(operators[j]==="÷"){
                result=result/numbers[i]
            }


            i++;
            j++;
        }

        resultScreenText = result;
        processArray=[];
    }


}
