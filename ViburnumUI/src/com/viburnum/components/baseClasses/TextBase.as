package com.viburnum.components.baseClasses
{
	import com.viburnum.core.UITextField;

    import com.viburnum.interfaces.IUITextField;
    import com.viburnum.utils.LayoutUtil;
    
    import flash.display.DisplayObject;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

	[Event(name="link", type="flash.events.TextEvent")]

	include "../../style/styleMetadata/TextStyle.as";
	include "../../style/styleMetadata/PaddingStyle.as";

	[Style(name="initTextFieldClass", type="Class")]

    public class TextBase extends BorderComponentBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				//TextStyle
				{name:"color", type:"uint", format:"Color", inherit:"yes"},
				{name:"disabledTextColor", type:"uint", format:"Color"},
				{name:"textAlign", type:"String", enumeration:"left,center,right,justify", inherit:"yes"},
				{name:"fontWeight", type:"String", enumeration:"normal,bold", inherit:"yes"},
				{name:"fontStyle", type:"String", enumeration:"normal,italic", inherit:"yes"},
				{name:"textDecoration", type:"String", enumeration:"none,underline", inherit:"yes"},
				{name:"kerning", type:"Boolean", inherit:"yes"},
				{name:"fontSize", type:"Number", format:"Length", inherit:"yes"},
				{name:"fontFamily", type:"String", inherit:"yes"},
				{name:"textIndent", type:"Number", format:"Length", inherit:"yes"},
				{name:"letterSpacing", type:"Number", inherit:"yes"},
				{name:"fontAntiAliasType", type:"String", enumeration:"normal,advanced", inherit:"yes"},
				{name:"fontThickness", type:"Number", inherit:"yes"},
				{name:"fontGridFitType", type:"String", enumeration:"none,pixel,subpixel", inherit:"yes"},
				{name:"fontSharpness", type:"Number", inherit:"yes"},
				
				//PaddingStyle
				{name:"paddingLeft", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingRight", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingTop", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingBottom", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
			]
		}
		
		protected var holdTextField:IUITextField;

		private var _isHTMLtext:Boolean = false;
		private var _text:String = "";
		private var _htmlText:String = "";
		private var _textContentChangedFlag:Boolean = false;
		
		private var _maxChars:uint = 0;//default - max
		private var _restrict:String = null;
		private var _maxChars2restrictChangedFlag:Boolean = false;

		private var _selectable:Boolean = true;
		private var _selectableChangedFlag:Boolean = false;
		
        public function TextBase()
        {
            super();
        }
		
		public function get text():String
		{
			return holdTextField == null ? _text : holdTextField.text || "";
		}
		
		[Inspectable(type="String")]
		public function set text(value:String):void
		{
			if(!value) value = "";
			
			_htmlText = "";
			
			_isHTMLtext = false;
			
			_text = value;
			_textContentChangedFlag = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get htmlText():String
		{
			return holdTextField == null ? _htmlText : holdTextField.htmlText || "";;
		}
		
		[Inspectable(type="String")]
		public function set htmlText(value:String):void
		{
			if(!value) value = "";
			
			_text = "";
			
			_isHTMLtext = true;
			
			_htmlText = value;
			_textContentChangedFlag = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get maxChars():int
		{
			return _maxChars;
		}
		
		[Inspectable(type="Number")]
		public function set maxChars(value:int):void
		{
			if(_maxChars == value)
			{
				_maxChars = value;
				
				_maxChars2restrictChangedFlag = true;
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		public function get restrict():String 
		{
			return _restrict;
		}
		
		[Inspectable(type="String")]
		public function set restrict(value:String):void
		{
			if(_restrict != value)
			{
				_restrict = value;
				
				_maxChars2restrictChangedFlag = true;
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			if(_selectable != value)
			{
				_selectable = value;
				
				_selectableChangedFlag = true;
				invalidateProperties();
			}
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "color" || 
				styleProp == "disabledColor" ||
				styleProp == "textAlign" ||
				styleProp == "fontWeight" ||
				styleProp == "fontStyle" ||
				styleProp == "textDecoration" ||
				styleProp == "kerning" ||
				styleProp == "fontSize" ||
				styleProp == "fontFamily" ||
				styleProp == "textIndent" ||
				styleProp == "letterSpacing" ||
				
				styleProp == "fontAntiAliasType" ||
				styleProp == "fontThickness" ||
				styleProp == "fontGridFitType" ||
				styleProp == "fontSharpness")
			{
				var f:TextFormat = new TextFormat();
				
//				var normalColor:uint = uint(getStyle("color"));
//				var disableColor:uint = getStyle("disabledColor") != undefined ? 
//					uint(getStyle("disabledColor")) :
//					ColorUtil.adjustBrightness2(normalColor, -50);
				f.color = enabled ? uint(getStyle("color")) : uint(getStyle("disabledColor"));
				f.align = getStyle("textAlign") || "left";
				f.bold = getStyle("fontWeight") == "bold";
				f.italic  = getStyle("fontStyle") == "italic";
				f.underline  = getStyle("textDecoration") == "underline";
				f.kerning  = Boolean(getStyle("kerning"));
				f.size = getStyle("fontSize") || 12;
				f.font = String(getStyle("fontFamily"));
				f.indent = Number(getStyle("textIndent"));
				f.letterSpacing = Number(getStyle("letterSpacing"));
				
				holdTextField.defaultTextFormat = f;
				holdTextField.setTextFormat(f);
				
				holdTextField.antiAliasType = getStyle("fontAntiAliasType") == AntiAliasType.ADVANCED ? 
					AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
				
				if(holdTextField.antiAliasType == AntiAliasType.ADVANCED)
				{
					holdTextField.thickness = Number(getStyle("fontThickness"));
					holdTextField.gridFitType = getStyle("fontGridFitType") == GridFitType.PIXEL ?
						GridFitType.PIXEL :
						(getStyle("fontGridFitType") == GridFitType.PIXEL ? GridFitType.PIXEL : GridFitType.NONE);
					
					holdTextField.sharpness = Number(getStyle("fontSharpness"));
				}
			}
		}

		override protected function onInitialize():void
		{
			super.onInitialize();

			holdTextField = createTextField();
			addChild(holdTextField as DisplayObject);
		}

		protected function createTextField():IUITextField
		{
			var textField:IUITextField;

			var textFieldClass:Class = getStyle("initTextFieldClass") || UITextField;

			if(textFieldClass != null)
			{
				textField = new textFieldClass();
//				textField.border = true;//test
			}
			
			return textField;
		}
		
		override protected function enableChanged():void
		{
			super.enableChanged();
			
			if(enabled)
			{
				notifyStyleChanged("color");
			}
			else
			{
				notifyStyleChanged("disabledColor");
			}
		}
		
		protected function updateTextFiledTypeSetting():void
		{
			holdTextField.selectable = enabled ? _selectable : false;
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_maxChars2restrictChangedFlag)
			{
				_maxChars2restrictChangedFlag = false;
				
				holdTextField.maxChars = _maxChars;
				holdTextField.restrict = _restrict;
			}
			
			if(_selectableChangedFlag)
			{
				_selectableChangedFlag = false;
				updateTextFiledTypeSetting();
			}
			
			if(_textContentChangedFlag)
			{
				_textContentChangedFlag = false;
				if(_isHTMLtext)
				{
					holdTextField.htmlText = _htmlText;
				}
				else
				{
					holdTextField.text = _text;
				}
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;

			var holdTextFieldAutoSizeType:String = holdTextField.autoSize;
			var holdTextFieldAutoSizeTypeChanged:Boolean = false;
			if(holdTextFieldAutoSizeType != TextFieldAutoSize.LEFT)
			{
				holdTextField.autoSize = TextFieldAutoSize.LEFT;
				holdTextFieldAutoSizeTypeChanged = true;
			}
			
			var holdTextFieldMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(holdTextField);
			var holdTextFieldMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(holdTextField);

			if(holdTextFieldAutoSizeTypeChanged)
			{
				holdTextField.autoSize = holdTextFieldAutoSizeType;
				LayoutUtil.setDisplayObjectSize(holdTextField, holdTextFieldMW, holdTextFieldMH);
			}
			
			var gapW:Number = bl + br + pl + pr;
			var gapH:Number = bt + bb + pt + pb;
			
			var measuredMW:Number = holdTextFieldMW + gapW;
			var measuredMH:Number = holdTextFieldMH + gapH;
			
			setMeasuredSize(measuredMW, measuredMH);
			
			//--
			
			var minW:Number = gapW;
			var minH:Number = gapH;
			
			setMeasuredMinSize(gapW, gapH);
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var left:Number = pl + bl;
			var top:Number = pt + bt;
			var right:Number = pr + br;
			var bottom:Number = pb + bb;

			var contenWidth:Number = layoutWidth - left - right;
			var contenHeight:Number = layoutHeight - top - bottom;
			
			LayoutUtil.setDisplayObjectLayout(holdTextField, left, top, contenWidth, contenHeight);
		}
    }
}