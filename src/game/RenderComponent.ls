package
{
	import loom.gameframework.AnimatedComponent;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import loom2d.ui.TextureAtlasSprite;
    
    public class RenderComponent extends AnimatedComponent
    {
        [Inject]
        protected var _entityLayer:Sprite;
    
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
            _entityLayer.addChild(_sprite);
                
            onFrame();
            
            return true;
        }
        
        override public function onRemove()
        {
            _entityLayer.removeChild(_sprite, true);
        
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