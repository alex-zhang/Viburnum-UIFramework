package com.viburnum.interfaces
{
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.text.StyleSheet;
    import flash.text.TextFormat;
    import flash.text.TextLineMetrics;
    
    public interface IUITextField
    {
        function get alwaysShowSelection():Boolean;
        function set alwaysShowSelection(value:Boolean):void;
        function get antiAliasType():String;
        function set antiAliasType(antiAliasType:String):void;
        function get autoSize():String;
        function set autoSize(value:String):void;
        function get background():Boolean;
        function set background(value:Boolean):void;
        function get backgroundColor():uint;
        function set backgroundColor(value:uint):void;
        function get border():Boolean;
        function set border(value:Boolean):void;
        function get borderColor():uint;
        function set borderColor(value:uint):void;
        function get bottomScrollV():int;
        function get caretIndex():int;
        function get condenseWhite():Boolean;
        function set condenseWhite(value:Boolean):void;
        function get defaultTextFormat():TextFormat;
        function set defaultTextFormat(format:TextFormat):void;
        function get embedFonts():Boolean;
        function set embedFonts(value:Boolean):void;
        function get gridFitType():String;
        function set gridFitType(gridFitType:String):void;
        function get htmlText():String;
        function set htmlText(value:String):void;
        function get length():int;
        function get maxChars():int;
        function set maxChars(value:int):void;
        function get maxScrollH():int;
        function get maxScrollV():int;
        function get mouseWheelEnabled():Boolean;
        function set mouseWheelEnabled(value:Boolean):void;
        function get multiline():Boolean;
        function set multiline(value:Boolean):void;
        function get numLines():int;
        function get displayAsPassword():Boolean;
        function set displayAsPassword(value:Boolean):void;
        function get restrict():String;
        function set restrict(value:String):void;
        function get scrollH():int;
        function set scrollH(value:int):void;
        function get scrollV():int;
        function set scrollV(value:int):void;
        function get selectable():Boolean;
        function set selectable(value:Boolean):void;
        function get selectionBeginIndex():int;
        function get selectionEndIndex():int;
        function get sharpness():Number;
        function set sharpness(value:Number):void;
        function get styleSheet():StyleSheet;
        function set styleSheet(value:StyleSheet):void;
        function get text():String;
        function set text(value:String):void;
        function get textColor():uint;
        function set textColor(value:uint):void;
        function get textHeight():Number;
        function get textWidth():Number;
        function get thickness():Number;
        function set thickness(value:Number):void;
        function get type():String;
        function set type(value:String):void;
        function get wordWrap():Boolean;
        function set wordWrap(value:Boolean):void;  
        function appendText(newText:String):void;
        function getCharBoundaries(charIndex:int):Rectangle;
        function getCharIndexAtPoint(x:Number, y:Number):int;
        function getFirstCharInParagraph(charIndex:int):int;
        function getLineIndexAtPoint(x:Number, y:Number):int;
        function getLineIndexOfChar(charIndex:int):int;
        function getLineLength(lineIndex:int):int;
        function getLineMetrics(lineIndex:int):TextLineMetrics;
        function getLineOffset(lineIndex:int):int;
        function getLineText(lineIndex:int):String;
        function getParagraphLength(charIndex:int):int;
        function getTextFormat(beginIndex:int=-1, endIndex:int=-1):TextFormat;
        function replaceSelectedText(value:String):void;
        function replaceText(beginIndex:int, endIndex:int, newText:String):void;
        function setSelection(beginIndex:int, endIndex:int):void;
        function setTextFormat(format:TextFormat,
                               beginIndex:int=-1,
                               endIndex:int=-1):void;
        function getImageReference(id:String):DisplayObject;
        function set useRichTextClipboard(value:Boolean):void;
        function get useRichTextClipboard():Boolean;
    }
}