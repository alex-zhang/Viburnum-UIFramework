package com.viburnum.components
{
    import com.viburnum.components.baseClasses.DropDownListBase;
    import com.viburnum.utils.LayoutUtil;

	/**
	 *  DropDownList 控件包含下拉列表，用户可从中选择单个值。
	 *  其功能与 HTML 中 SELECT 表单元素的功能非常相似。 
	 *
	 *  <p>DropDownList 控件由锚点按钮、提示区域和下拉列表组成，使用锚点按钮可打开和关闭下拉列表。
	 * 提示区域显示一个提示 String，或者显示下拉列表中的选定项目。</p>
	 *
	 *  <p>打开下拉列表时：</p>
	 *  <ul>
	 *    <li>单击锚点按钮会关闭下拉列表并提交当前选定的数据项目。</li>
	 *    <li>在下拉列表之外单击会关闭下拉列表并提交当前选定的数据项目。</li>
	 *    <li>在某个数据项目上单击会选中该项目并关闭下拉列表。</li>
	 *    <li>如果 requireSelection 属性为 false，则按下 Ctrl 键的同时单击某个数据项目会取消选中该项目并关闭下拉列表。</li>
	 *  </ul>
	 *
	 *  <p><b>注意:</b>基于 Spark List 的控件（Spark ListBase 类及其子类，如 ButtonBar、ComboBox、DropDownList、List 和 TabBar）不支持将 BasicLayout 类作为 layout 属性的值。
	 * 不要将 BasicLayout 与基于 Spark List 的控件一起使用。</p>
	 *
	 *  @author zhangcheng01
	 */
	
	include "../style/styleMetadata/StatedBackgroundStyle.as";
	include "../style/styleMetadata/PaddingStyle.as";
	
    public class DropDownList extends DropDownListBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				//StatedBackgroundStyle
				{name:"backgroundSkin", type:"Class", skinClass:"true"},
				{name:"backgroundSkin_upSkin", type:"Class"},
				{name:"backgroundSkin_overSkin", type:"Class"},
				{name:"backgroundSkin_downSkin", type:"Class"},
				{name:"backgroundSkin_disabledSkin", type:"Class"},
				
				//PaddingStyle
				{name:"paddingLeft", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingRight", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingTop", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingBottom", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
			]
		}
		
		private var _prompt:String = "";
		private var _labelChangedFlag:Boolean = false;

        public function DropDownList()
        {
            super();
        }
		
		public function get prompt():String
		{
			return _prompt;
		}
		
		[Inspectable(type="String")]
		public function set prompt(value:String):void
		{
			if(_prompt == value) return;
			
			_prompt = value;
			_labelChangedFlag = true;
			invalidateProperties();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			openButton = new Button();
			addChild(openButton);
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);

			if(styleProp == "backgroundSkin" || styleProp == "backgroundSkin_upSkin" || 
				styleProp == "backgroundSkin_overSkin" || styleProp == "backgroundSkin_downSkin" ||
				styleProp == "backgroundSkin_disabledSkin" || 
				styleProp == "paddingLeft" || styleProp == "paddingTop" || 
				styleProp == "paddingRight" || styleProp == "paddingBottom")
			{
				openButton.setStyle(styleProp, getStyle(styleProp));
			}
		}

		override protected function measure():void
		{
			super.measure();
			
			setMeasuredSize(openButton.measuredWidth, openButton.measuredHeight);
			setMeasuredMinSize(openButton.minWidth, openButton.minHeight);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
		
			LayoutUtil.setDisplayObjectSize(openButton, layoutWidth, layoutHeight);
		}
    }
}