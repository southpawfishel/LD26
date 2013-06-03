package
{
	import Loom.GameFramework.AnimatedComponent;
	import Loom2D.Display.Sprite;
	import Loom2D.Display.Stage;
	import Loom2D.UI.TextureAtlasSprite;
    
    public class RenderComponent extends AnimatedComponent
    {
        [Inject]
        protected var _stage:Stage;
    
        protected var _sprite:TextureAtlasSprite;
        protected var _texture:String;
        
        public function RenderComponent()
        {
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
            
            _sprite = new TextureAtlasSprite();
            _sprite.atlasName = "sprites";
            _stage.addChild(_sprite);
                
            onFrame();
            
            return true;
        }
        
        override public function onRemove()
        {
            _stage.removeChild(_sprite, true);
        
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
            _sprite.pivotX = _sprite.width / 2;
            _sprite.pivotY = _sprite.height / 2;
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