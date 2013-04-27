package
{
    import Loom.GameFramework.AnimatedComponent;
    
    import cocos2d.CCSprite;
    import cocos2d.CCScaledLayer;
    
    public class RenderComponent extends AnimatedComponent
    {
        [Inject]
        protected var _gameLayer:CCScaledLayer;
    
        protected var _sprite:CCSprite;
        
        public function RenderComponent()
        {
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
            
            _sprite = CCSprite.create();
            _gameLayer.addChild(_sprite);
                
            onFrame();
            
            return true;
        }
        
        override public function onRemove()
        {
            _gameLayer.removeChild(_sprite, true);
        
            super.onRemove();
        }
        
        public function set x(value:Number)
        {
            _sprite.x = value;
        }
        
        public function set y(value:Number)
        {
            _sprite.y = value;
        }
        
        public function set texture(value:String)
        {
            _sprite.texture = value;
        }
        
        public override function onFrame()
        {
            super.onFrame();
        }
    }
}