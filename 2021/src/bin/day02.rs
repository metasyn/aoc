mod util;


use std::str::FromStr;

#[derive(Debug)]
enum Direction {
    Forward,
    Up,
    Down,
}

#[derive(Debug)]
struct Line {
    direction: Direction,
    distance: i32,
}

impl FromStr for Line {
    type Err = std::num::ParseIntError;

    fn from_str(line: &str) -> Result<Self, Self::Err> {
        let split = line.split(" ").collect::<Vec<&str>>();
        if split.len() != 2 {
            panic!("invalid")
        }
        let direction: Direction = match split[0].chars().next().unwrap() {
            'f' => Direction::Forward,
            'u' => Direction::Up,
            _ => Direction::Down,
        };
        let distance : i32 = split[1].parse::<i32>().unwrap();

        Ok(Line { direction: direction, distance: distance})
    }
}


fn calculate_position(vec: &Vec<Line>) -> i32 {
    let mut distance = 0;
    let mut depth = 0;
    for v in vec {
        match v.direction {
            Direction::Forward => distance += v.distance,
            Direction::Up => depth -= v.distance,
            Direction::Down => depth += v.distance,
        }
    }
    return distance * depth;
}

fn calculate_position_with_aim(vec: &Vec<Line>) -> i32 {
    let mut distance = 0;
    let mut depth = 0;
    let mut aim = 0;

    for v in vec {
        match v.direction {
            Direction::Forward => {
                distance += v.distance;
                depth += aim * v.distance;
            },
            Direction::Up => {
                aim -= v.distance;
            },
            Direction::Down => {
                aim += v.distance;
            }
        }
    }
    return distance * depth;
}

fn main() -> Result<(), ()> {
    let _input: Vec<Line> = util::load_file_split("input/day02.txt").unwrap()
        .iter()
        .filter(|x| !x.is_empty())
        .map(|x| Line::from_str(x))
        .filter_map(|x| x.ok())
        .collect();

    let sample = vec![
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2"
    ].iter()
     .map(|x| Line::from_str(x))
     .filter_map(|x| x.ok())
     .collect();

    let ans = calculate_position(&sample);
    println!("{} should be 150", ans);

    let ans = calculate_position(&_input);
    println!("part 1 answer is {}", ans);

    let ans = calculate_position_with_aim(&sample);
    println!("{} should be 900", ans);

    let ans = calculate_position_with_aim(&_input);
    println!("part 2 answer is {}", ans);

    return Ok(());
}
