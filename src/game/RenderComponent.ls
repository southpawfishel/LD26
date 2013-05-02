package
{
    import Loom2D.UI.AtlasSprite;
    import Loom2D.Display.Sprite;
    import Loom2D.Display.Stage;
    import Loom.GameFramework.AnimatedComponent;
    
    public class RenderComponent extends AnimatedComponent
    {
        [Inject]
        protected var _gameLayer:Stage;
        [Inject]
        protected var _batchNode:Sprite;
    
        protected var _sprite:AtlasSprite;
        protected var _texture:String;
        
        public function RenderComponent()
        {
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
            
            _sprite  = new AtlasSprite();
            _sprite.atlasName = "sprites";
            _sprite.center = true;
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
        
        public function set alpha(value:int)
        {
            if (!_sprite) return;
            _sprite.alpha = value;
        }
        
        public function set texture(value:String)
        {
            if (!_sprite) return;
            if (_sprite.textureName == value) return;
            _sprite.textureName = value;
        }
        
        public function set r(value:Number)
        {
            if (!_sprite) return;
            _sprite.r = value;
        }
        
        public function set g(value:Number)
        {
            if (!_sprite) return;
            _sprite.g = value;
        }
        
        public function set b(value:Number)
        {
            if (!_sprite) return;
            _sprite.b = value;
        }
        
        
        public override function onFrame()
        {
            super.onFrame();
        }
    }
}