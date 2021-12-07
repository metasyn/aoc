mod util;

use std::num::ParseIntError;
use std::str::FromStr;
use std::cmp::{max, min};
use std::collections::HashMap;
use std::hash::{Hash, Hasher};

#[derive(Debug, Clone, Copy)]
struct Point {
    x: i32,
    y: i32,
}

impl FromStr for Point {
    type Err = ParseIntError;

    fn from_str(input: &str) -> Result<Self, Self::Err> {
        let split = input
            .split(",")
            .map(|x| x.parse::<i32>().unwrap())
            .collect::<Vec<i32>>();
        return Ok(Point {
            x: split[0],
            y: split[1],
        });
    }
}
impl PartialEq for Point {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}

impl Eq for Point {}

impl Hash for Point{
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.x.hash(state);
        self.y.hash(state);
    }
}


#[derive(Debug)]
struct Line {
    start: Point,
    end: Point,
}

impl FromStr for Line {
    type Err = ParseIntError;

    fn from_str(input: &str) -> Result<Self, Self::Err> {
        let split = input
            .split(" -> ")
            .map(|x| Point::from_str(x).unwrap())
            .collect::<Vec<Point>>();
        return Ok(Line {
            start: split[0],
            end: split[1],
        });
    }
}

impl PartialEq for Line {
    fn eq(&self, other: &Self) -> bool {
        self.start == other.start && self.end == other.end
    }
}

impl Eq for Line {}

impl Line {
    pub fn to_points(self) -> (Vec<Point>, i32, i32) {
        let xmax = max(self.start.x, self.end.x) ;
        let ymax = max(self.start.y, self.end.y);

        let dx = self.end.x - self.start.x;
        let dy = self.end.y - self.start.y;

        let mut points = vec![];

        if dx == 0 {
            // Vertical
            let x = self.start.x;
            let start = min(self.start.y, self.end.y);
            let end = max(self.start.y, self.end.y);
            for y in start..=end{
                points.push(Point{x, y})
            }
        }
        else if dy == 0 {
            // Horizontal
            let y = self.start.y;
            let start = min(self.start.x, self.end.x);
            let end = max(self.start.x, self.end.x);
            for x in start..=end {
                points.push(Point{x, y})
            }
        } else {
            // Diagonal

            let xsign = if dx > 0 { 1 } else { -1};
            let ysign = if dy > 0 { 1 } else { -1 };

            let lim = dx.abs();

            for i in 0..=lim {
                points.push(Point{x: self.start.x + (i * xsign), y: self.start.y + (i * ysign)});
            }
        }

        return (points, xmax, ymax);
    }
}

fn main() {
    let path = "input/day05.txt";

    let mut xdim = 0;
    let mut ydim = 0;

    let answer = util::load_file_split(path)
        .unwrap()
        .iter()
        .filter(|x| !x.is_empty())
        .map(|x| {
            let (points, x, y) = Line::from_str(x).unwrap().to_points();
            xdim = max(xdim, x);
            ydim = max(ydim, y);
            return points;
        })
        .flatten()
        .fold(HashMap::new(),
            |mut map, point| {
                *map.entry(point).or_insert(0) += 1;
                map
            })
        .into_values()
        .filter(|&x| x >= 2)
        .count();

    println!("{:?}", answer);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn day05_test_point_from_str() {
        assert_eq!(Point::from_str("1,2").unwrap(), Point { x: 1, y: 2 });
    }

    #[test]
    fn day05_test_coord_from_str() {
        assert_eq!(
            Line::from_str("1,2 -> 3,4").unwrap(),
            Line {
                start: Point { x: 1, y: 2 },
                end: Point { x: 3, y: 4 },
            }
        );
    }

    #[test]
    fn day05_test_line_to_points_vertical_up() {
        let (points, x, y) = Line::from_str("0,1 -> 0,3").unwrap().to_points();
        assert_eq!(x, 0);
        assert_eq!(y, 3);
        assert_eq!(
            points,
            vec![Point{x: 0, y: 1}, Point{x: 0, y: 2}, Point{x: 0, y: 3}],
        )
    }

    #[test]
    fn day05_test_line_to_points_vertical_down() {
        let (points, x, y) = Line::from_str("0,3 -> 0,1").unwrap().to_points();
        assert_eq!(x, 0);
        assert_eq!(y, 3);
        assert_eq!(
            points,
            vec![Point{x: 0, y: 1}, Point{x: 0, y: 2}, Point{x: 0, y: 3}],
        )
    }

    #[test]
    fn day05_test_line_to_points_horizontal_right() {
        let (points, x, y) = Line::from_str("1,0 -> 3,0").unwrap().to_points();
        assert_eq!(x, 3);
        assert_eq!(y, 0);
        assert_eq!(
            points,
            vec![Point{y: 0, x: 1}, Point{y: 0, x: 2}, Point{y: 0, x: 3}],
        )
    }

    #[test]
    fn day05_test_line_to_points_horizontal_left() {
        let (points, x, y) = Line::from_str("3,0 -> 1,0").unwrap().to_points();
        assert_eq!(x, 3);
        assert_eq!(y, 0);
        assert_eq!(
            points,
            vec![Point{y: 0, x: 1}, Point{y: 0, x: 2}, Point{y: 0, x: 3}],
        )
    }

    #[test]
    fn day05_test_line_to_points_up_left() {
        let (points, x, y) = Line::from_str("3,3 -> 1,1").unwrap().to_points();
        assert_eq!(x, 3);
        assert_eq!(y, 3);
        assert_eq!(
            points,
            vec![Point{y: 3, x: 3}, Point{y: 2, x: 2}, Point{y: 1, x: 1}],
        )
    }

    #[test]
    fn day05_test_line_to_points_up_right() {
        let (points, x, y) = Line::from_str("1,1 -> 3,3").unwrap().to_points();
        assert_eq!(x, 3);
        assert_eq!(y, 3);
        assert_eq!(
            points,
            vec![Point{y: 1, x: 1}, Point{y: 2, x: 2}, Point{y: 3, x: 3}],
        )
    }
}
