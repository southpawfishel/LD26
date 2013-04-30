package
{
    import Loom.GameFramework.LoomGameObject;
    import Loom.GameFramework.TickedComponent;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    
    import Loom.Animation.Tween;
    import Loom.Animation.EaseType;
    
    import CocosDenshion.SimpleAudioEngine;
    import cocos2d.CCScaledLayer;
    import cocos2d.ccColor3B;
    
    public delegate PlayerOrbDeathCallback(orb:PlayerOrbComponent, object:LoomGameObject):void;
    public delegate PolarityChangedCallback(polarity:int):void;
    
    public class PlayerOrbComponent extends TickedComponent
    {
        [Inject]
        protected var _gameLayer:CCScaledLayer;
        
        protected var _texture:String;
        
        protected var _actor:ActorComponent;
        protected var _alive:Boolean = false;
        
        protected var _trackingDrag:Boolean = false;
        protected var _trackingDragId:int = -1;
        
        public static var GOOD_SFX = "assets/boop.wav";
        public static var BAD_SFX = "assets/beep.wav";
        
        protected var _polarity:int = 0;
        
        public var onDeath:PlayerOrbDeathCallback = new PlayerOrbDeathCallback();
        public var onPolarityChanged:PolarityChangedCallback = new PolarityChangedCallback();
        
        public function set texture(value:String)
        {
            _texture = value;
        }
        
        public function get texture():String
        {
            return _texture;
        }
        
        public function PlayerOrbComponent()
        {
            texture = "whiteorb.png";
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
                
            _actor = owner.lookupComponentByName("actor") as ActorComponent;
            _actor.radius = 35;
                
            _gameLayer.onTouchBegan += onTouchBegan;
            _gameLayer.onTouchMoved += onTouchMoved;
            _gameLayer.onTouchEnded += onTouchEnded;
            
            return true;
        }
        
        override public function onRemove()
        {
            _gameLayer.onTouchBegan -= onTouchBegan;
            _gameLayer.onTouchMoved -= onTouchMoved;
            _gameLayer.onTouchEnded -= onTouchEnded;
            
            super.onRemove();
        }
        
        override public function onTick()
        {
            _actor.position.x = Math.clamp(_actor.position.x, _actor.radius, _gameLayer.designWidth - _actor.radius);
            _actor.position.y = Math.clamp(_actor.position.y, _actor.radius, _gameLayer.designHeight - _actor.radius);
        }
        
        public function onTouchBegan(id:int, touchX:Number, touchY:Number)
        {
            if (_trackingDrag) return;
            if (_alive && !_actor.pointWithinRadius(touchX, touchY)) return;
            
            if (!_alive)
            {
                Tween.to(_actor, 0.15, { "scale" : 1, "opacity" : 255, "ease" : EaseType.EASE_IN }).onComplete += function()
                {
                    _alive = true;
                }
            }
            
            _trackingDrag = true;
            _trackingDragId = id;
            _actor.setPosition(touchX, touchY);
        }
        
        protected function onTouchMoved(id:int, touchX:Number, touchY:Number)
        {
            if (_trackingDragId != id) return;
            
            _actor.setPosition(touchX, touchY);
        }
        
        protected function onTouchEnded(id:int, touchX:Number, touchY:Number)
        {
            if (_trackingDrag && _trackingDragId == id)
            {
                _trackingDrag = false;
                _trackingDragId = -1;
            }
        }
        
        public function handleCollisionWithOrb(orb:LoomGameObject)
        {
            var behavior = orb.lookupComponentByName("behavior") as OrbBehaviorComponent;
            if (!behavior || !behavior.alive) return;
            
            // Update our polarity
            if (_polarity == 0)
            {
                if (behavior.type == orbType.Plus) ++_polarity;
                else if (behavior.type == orbType.Minus) --_polarity;
                SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
            }
            else if (_polarity > 0)
            {
                if (behavior.type == orbType.Plus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(GOOD_SFX);
                    ++_polarity;
                }
                else if (behavior.type == orbType.Minus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
                    --_polarity;
                }
            }
            else
            {
                if (behavior.type == orbType.Plus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(GOOD_SFX);
                    ++_polarity;
                }
                else if (behavior.type == orbType.Minus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
                    --_polarity;
                }
            }
            
            onPolarityChanged(_polarity);
            
            // Determine our dominant color based on what we've absorbed
            var dominantColor = new ccColor3B(255, 255, 255);
            if (_polarity < 0)
            {
                dominantColor = ColorUtils.intToRGB(OrbBehaviorComponent.colors[0]);
            }
            else if (_polarity > 0)
            {
                dominantColor = ColorUtils.intToRGB(OrbBehaviorComponent.colors[1]);
            }
            
            // Scale based on our polarity
            var newScale = 1.0 + (0.1 * Math.abs(_polarity));
            
            // Tween to these new values
            Tween.to(_actor, 0.2, { "r" : dominantColor.r, "g" : dominantColor.g, "b" : dominantColor.b, "scale" : newScale });
            
            // Kill the orb we collided with
            behavior.kill();
        }
    }
}
