package
{
    import Loom.GameFramework.TickedComponent;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    
    import cocos2d.CCPoint;
    
    public class ActorComponent extends TickedComponent
    {
        protected var _position:Point2 = new Point2(0, 0);
        protected var _velocity:Point2 = new Point2(0, 0);
        
        public function ActorComponent()
        {
        }
        
        public function set x(value:Number)
        {
            _position.x = value;
        }
        
        public function get x():Number
        {
            return _position.x;
        }
        
        public function set y(value:Number)
        {
            _position.y = value;
        }
        
        public function get y():Number
        {
            return _position.y;
        }
        
        public function set position(value:Point2)
        {
            _position = value;
        }
        
        public function get position():Point2
        {
            return _position;
        }
        
        public function setPosition(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;
        }
        
        public function set velocity(value:Point2)
        {
            _velocity = value;
        }
        
        public function get velocity():Point2
        {
            return _velocity;
        }
        
        public override function onTick()
        {
            _position = _position + MathUtils.scalePoint(_velocity, timeManager.TICK_RATE);
        }
    }
}