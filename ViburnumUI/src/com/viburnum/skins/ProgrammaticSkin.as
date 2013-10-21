package com.viburnum.skins
{
	import com.viburnum.core.LayoutSpriteElement;
	import com.viburnum.interfaces.IStyleClient;
	import com.viburnum.interfaces.IStyleNotifyer;

    public class ProgrammaticSkin extends LayoutSpriteElement implements ISkin, IStyleNotifyer
    {
		//皮肤的度量尺寸改变时默认是不通知父容器度量和布局的，皮肤一般做拉伸适应
		private var _skinPartName:String = "";

        public function ProgrammaticSkin()
        {
			super();
        }
		
        //ISkin Interface=======================================================
		public function getStyle(styleProp:String):*
		{
			return owner is IStyleClient ?
				IStyleClient(parent).getStyle(skinPartName + "_" + styleProp) :
				undefined;
		}
		
		public function getHostStyle(styleProp:String):*
		{
			return owner is IStyleClient ?
				IStyleClient(parent).getStyle(styleProp) :
				undefined;
		}

		public function set skinPartName(value:String):void
		{
			_skinPartName = value;
		}
		
		public function get skinPartName():String
		{
			return _skinPartName;
		}
		
		public function getSkinPartStyleProp(styleProp:String):String
		{
			if(_skinPartName == styleProp) return styleProp;
			
			var skinPartStyleProp:String = styleProp.substring(_skinPartName.length + 1);
			return skinPartStyleProp;
		}

		//IStyleNotifyer Interface================================
        public function notifyStyleChanged(styleProp:String):void
        {
			invalidateDisplayList();
        }
    }
}