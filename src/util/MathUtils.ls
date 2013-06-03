package
{
    import Loom2D.Math.Point;
    
    class MathUtils
    {
        public static function subtractPoint(p1:Point, p2:Point):Point
        {
            var ret:Point = new Point();
            ret.x = p1.x - p2.x;
            ret.y = p1.y - p2.y;
            return ret;
        }
    
        public static function scalePoint(point:Point, scalar:Number):Point
        {
            var ret:Point = new Point();
            ret.x = point.x * scalar;
            ret.y = point.y * scalar;
            return ret;
        }
        
        public static function squareDistance(p1:Point, p2:Point):Number
        {
            return Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2);
        }

        public static function squareMagnitude(p:Point):Number
        {
            return Math.pow(p.x, 2) + Math.pow(p.y, 2);
        }
        
        public static function randomInRange(min:int, max:int):int
        {
            return Math.floor(min + (Math.random() * (max - min)));
        }
        
        public static function randomSign():int
        {
            return Math.random() < 0.5 ? -1 : 1;
        }
        
        public static function randomPoint(minX:Number, minY:Number, maxX:Number, maxY:Number):Point
        {
            var ret:Point = new Point();
            ret.x = randomInRange(minX, maxX);
            ret.y = randomInRange(minY, maxY);
            return ret;
        }
    }
}