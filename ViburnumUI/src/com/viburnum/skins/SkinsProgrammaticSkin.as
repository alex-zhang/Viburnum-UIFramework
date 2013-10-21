package com.viburnum.skins
{
	import com.alex.utils.ClassFactory;
	import com.viburnum.interfaces.IStateClient;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	public class SkinsProgrammaticSkin extends StateableProgrammaticSkin
	{
		private var _currentStateSkin:DisplayObject;

		public function SkinsProgrammaticSkin()
		{
			super();
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			var skinPartStateName:String = findValideSkinPartSkinStateNameByStyleProp(styleProp);

			if(skinPartStateName != null)
			{
				regenerateSkinByState(skinPartStateName);
			}
		}

		private function selecteSkinPartByStateName(state:String):void
		{
			var targetSkinPart:DisplayObject = getSkinPartByStateName(state);

			if(targetSkinPart == null)
			{
				regenerateSkinByState(state);
				
				targetSkinPart = getSkinPartByStateName(state);
			}
			
			if(_currentStateSkin != targetSkinPart)
			{
				//new
				if(targetSkinPart != null)
				{
					targetSkinPart.visible = true;
				}

				//last
				if(_currentStateSkin != null)
				{
					_currentStateSkin.visible = false;
				}
				
				_currentStateSkin = targetSkinPart;
			}
		}
		
		private function regenerateSkinByState(state:String):void
		{
			var skinPart:DisplayObject = getSkinPartByStateName(state);
			if(skinPart != null)
			{
				removeChild(skinPart);
			}

			//这里皮肤的生成可能是Class或ClassFactory(做些配置)
			var targetSkinFactory:* /*Class or ClassFactory*/ = getSkinPartSkinClassFactoryByStateName(state);
			if(targetSkinFactory)
			{
				if(targetSkinFactory is Class)
				{
					skinPart = new targetSkinFactory();
				}
				else if(targetSkinFactory is ClassFactory)
				{
					skinPart = ClassFactory(targetSkinFactory).newInstance();
				}
				
				if(skinPart != null)
				{
					var skinPartName:String = getSkinPartNameByStateName(state);
					skinPart.name = skinPartName;
					
					if(skinPart is ISkin)
					{
						ISkin(skinPart).skinPartName = skinPartName;
					}
					
					if(skinPart is IStateClient)
					{
						IStateClient(skinPart).currentState = currentState;
					}
					
					addChild(skinPart);
				}
			}
		}

		private function getSkinPartSkinClassFactoryByStateName(state:String):*//Class or ClassFactory
		{
			return getStyle(state + "Skin");
		}
		
		private function hasDefineSkinPartSkinByStateName(state:String):Boolean
		{
			var v:* = getStyle(state + "Skin");
			return v !== undefined;
		}
		
		private function getSkinPartNameByStateName(state:String):String
		{
			return skinPartName + "_" + state + "Skin";
		}
		
		private function getSkinPartByStateName(state:String):DisplayObject
		{
			var skinPartName:String = getSkinPartNameByStateName(state);
			var skinPart:DisplayObject = getChildByName(skinPartName);

			return skinPart;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var mesuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_currentStateSkin);
			var mesuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_currentStateSkin);

			setMeasuredSize(mesuredW, mesuredH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);	
			
			LayoutUtil.setDisplayObjectSize(_currentStateSkin, layoutWidth, layoutHeight);
		}
		
		override protected function currentStateChanged(value:String):void
		{
			invalidateSize();

			selecteSkinPartByStateName(value);
		}
		
		//skinPartName + "_" + state + "Skin"
		private function findValideSkinPartSkinStateNameByStyleProp(styleProp:String):String
		{
			var index:int = styleProp.indexOf("Skin");
			if(index == -1 || index == 0) return null;

			var stateName:String = styleProp.substring(0, index);
			return stateName;
		}
	}
}