package com.viburnum.components
{
    import com.viburnum.components.baseClasses.DropDownListBase;
    import com.viburnum.utils.LayoutUtil;
	
	[Style(name="openButtonStyleName", type="String")]
	[Style(name="textInputStyleName", type="String")]
	
	/**
	 * ComboBox 控件是 DropDownListBase 控件的子类.
	 * 
	 * <p>DropDownListBase 控件类似，当用户从 ComboBox 控件的下拉列表中选择某项时，数据项将显示在控件的提示区域中。</p>
	 * 
	 * <p>这两个控件之间的一个区别是，ComboBox 控件的提示区域是使用 TextInput 控件实现的，而 DropDownList 控件是通过 Label 控件实现的。
	 * 因此，用户可以编辑控件的提示区域，以输入非预定义选项之一的值。</p>
	 * 
	 * <p>例如，DropDownList 控件仅允许用户从控件的预定义项列表中进行选择。
	 * ComboBox 控件允许用户既可以从预定义项中选择，也可以在提示区域中输入新项。
	 * 您的应用程序可以识别已输入一个新项，（可选）并将其添加到控件的项列表中。</p>
	 * 
	 * <p>ComboBox 控件还可以当用户在提示区域中输入字符时搜索项列表。当用户输入字符时，
	 * 将打开控件的下拉区域，然后滚动到项列表中最接近的匹配项并加亮。</p>
	 * 
	 * @author zhangcheng01
	 * 
	 */
    public class ComboBox extends DropDownListBase
    {
		public static function getStyleDefinition():Array 
		{
			return [
				{name:"openButtonStyleName", type:"String"},
				{name:"textInputStyleName", type:"String"},
			]
		}
		/**
		 *  如果为 true，则用户编辑提示区域时会打开下拉列表。
		 * 
		 *  @default true 
		 *  
		 */ 
		public var openOnInput:Boolean = true;
		
		protected var textInput:TextInput;

		private var _labelToItemFunctionChangedFlag:Boolean = false;
		private var _labelToItemFunction:Function;

		private var _maxChars:int = 0;
		private var _maxCharsChangedFlag:Boolean = false;

		private var _restrict:String;
		private var _restrictChangedFlag:Boolean;
		
//		/**
//		 *  指定当用户在提示区域中输入字符时用于搜索项列表的回调函数。
//		 * 当用户输入字符时，将打开控件的下拉区域，然后滚动到项列表中最接近的匹配项并加亮。 
//		 * 
//		 *  <p>该属性引用的函数采用输入字符串，并返回数据提供程序中与输入相匹配的项的索引。
//		 * 这些项将在数据提供程序中。作为索引的 Vector <int> 返回。</p>
//		 * 
//		 *  <p>该回调函数必须具有以下签名： </p>
//		 * 
//		 *  <pre>function myMatchingFunction(comboBox:ComboBox, inputText:String):Vector.&lt;int&gt;</pre>
//		 * 
//		 *  <p>如果该属性的值为 null，ComboBox 使用默认算法查找匹配项。
//		 * 默认情况下，如果长度为 n 的输入字符串等同于某项的前 n 个字符（忽略大小写），则它为该项的匹配项。
//		 * 例如，“aRiz”是“Arizona”的匹配项，而“riz”则不是。要禁止搜寻，请创建返回空 Vector。<int> 的回调函数。</p>
//		 * 
//		 * <p>默认值为 null。</p>
//		 *
//		 * @author zhangcheng01
//		 * 
//		 */
//		public var itemMatchingFunction:Function = null;
		
        public function ComboBox()
        {
            super();
        }
		
		/**
		 *  指定用于将在提示区域中输入的新值转换为与数据提供程序中的数据项具有相同数据类型的回调函数。
		 * 当提示区域中的文本提交且在数据提供程序中未找到时，将调用该属性引用的函数。 
		 * 
		 *  <p>该回调函数必须具有以下签名： </p>
		 * 
		 *  <pre>function myLabelToItem(value:String):Object</pre>
		 * 
		 *  <p>其中，value 是在提示区域中输入的 String。该函数返回其类型与数据提供程序中的项相同的 Object。</p>
		 * 
		 *  <p>默认回调函数返回 value。 </p>
		 *  
		 * @author zhangcheng01
		 * 
		 */ 
		public function get labelToItemFunction():Function
		{
			return _labelToItemFunction;
		}
		
		public function set labelToItemFunction(value:Function):void
		{
			if(_labelToItemFunction == value) return;
			
			_labelToItemFunction = value;
			_labelToItemFunctionChangedFlag = true;
			invalidateProperties();
		}
		
		/**
		 *  提示区域中最多可包含的字符数（即用户输入的字符数）。0 值相当于无限制。  
		 * 
		 *  <p>默认值为 0。</p>
		 *  
		 *  @author zhangcheng01
		 * 
		 */ 
		public function get maxChars():int
		{
			return _maxChars;
		}
		
		[Inspectable(type="Number")]
		public function set maxChars(value:int):void
		{
			if (value == _maxChars)
				return;
			
			_maxChars = value;
			_maxCharsChangedFlag = true;
			invalidateProperties();
		}
		
		/**
		 *  指定用户可以在提示区域中输入的字符集。默认情况下，用户可以输入任意字符，相当于空字符串的值。 
		 * 
		 *  @default ""
		 * 
		 *  @author zhangcheng01
		 * 
		 */ 
		public function get restrict():String
		{
			return _restrict;
		}
		
		[Inspectable(type="String")]
		public function set restrict(value:String):void
		{
			if(_restrict == value) return;
			
			_restrict = value;
			_restrictChangedFlag = true;
			invalidateProperties();
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);

			if(styleProp == "openButtonStyleName")
			{
				openButton.styleName = getStyle(styleProp);
			}
			else if(styleProp == "textInputStyleName")
			{
				textInput.styleName = getStyle(styleProp);
			}
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			textInput = new TextInput();
			textInput.displayAsPassword = true;
			addChild(textInput);
			
			openButton = new SimpleButton();
			addChild(openButton);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var textInputMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(textInput);
			var textInputMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(textInput);
			
			var textInputMinW:Number = LayoutUtil.getDisplayObjectMinWidth(textInput);
			var textInputMinH:Number = LayoutUtil.getDisplayObjectMinHeight(textInput);
			
			var openButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(openButton);
			var openButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(openButton);
			
			var measuredW:Number = textInputMW + openButtonMW;
			var measuredH:Number = Math.max(textInputMH, openButtonMH);
			
			var measuredMinW:Number = textInputMinW + openButtonMW;
			var measuredMinH:Number = Math.max(textInputMinH, openButtonMH);
			
			setMeasuredSize(measuredW, measuredH);
			setMeasuredMinSize(measuredMinW, measuredMinH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var openButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(openButton);
			var openButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(openButton);
			
			LayoutUtil.setDisplayObjectSize(textInput, layoutWidth - openButtonMW, layoutHeight);
			
			LayoutUtil.setDisplayObjectLayout(openButton, layoutWidth - openButtonMW, 
				0, openButtonMW, layoutHeight);
		}
    }
}