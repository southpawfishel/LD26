package
{
    import Loom.GameFramework.AnimatedComponent;
    
    import cocos2d.CCSprite;
    import cocos2d.CCSpriteFrame;
    import cocos2d.CCSpriteFrameCache;
    import cocos2d.CCSpriteBatchNode;
    import cocos2d.CCScaledLayer;
    import cocos2d.ccColor3B;
    
    public class RenderComponent extends AnimatedComponent
    {
        [Inject]
        protected var _gameLayer:CCScaledLayer;
        [Inject]
        protected var _batchNode:CCSpriteBatchNode;
    
        protected var _sprite:CCSprite;
        protected var _texture:String;
        
        public function RenderComponent()
        {
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
            
            _sprite = CCSprite.createFromFile("assets/sprites.png");
            _batchNode.addChild(_sprite);
                
            onFrame();
            
            return true;
        }
        
        override public function onRemove()
        {
            _batchNode.removeChild(_sprite, true);
        
            super.onRemove();
        }
        
        public function set x(value:Number)
        {
            if (!_sprite) return;
            _sprite.x = value;
        }
        
        public function set y(value:Number)
        {
            if (!_sprite) return;
            _sprite.y = value;
        }
        
        public function set scale(value:Number)
        {
            if (!_sprite) return;
            _sprite.scale = value;
        }
        
        public function set opacity(value:int)
        {
            if (!_sprite) return;
            _sprite.setOpacity(value);
        }
        
        public function set texture(value:String)
        {
            if (!_sprite) return;
            if (_texture == value) return;
            _texture = value;
            _sprite.setDisplayFrame(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(value));
        }
        
        protected var _r:int, _g:int, _b:int;
        
        public function get r():int { return _r; };
        public function get g():int { return _g; };
        public function get b():int { return _b; };
        
        public function set r(value:int):void { _r = value; setColor(new ccColor3B(_r, _g, _b)); };
        public function set g(value:int):void { _g = value; setColor(new ccColor3B(_r, _g, _b)); };
        public function set b(value:int):void { _b = value; setColor(new ccColor3B(_r, _g, _b)); };
        
        public function setColor(color:ccColor3B)
        {
            if (!_sprite) return;
            _sprite.setColor(color);
        }
        
        public override function onFrame()
        {
            super.onFrame();
        }
    }
}