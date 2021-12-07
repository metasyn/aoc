mod util;

fn main() {
    let path = "input/day07.txt";
    let positions = util::load_file(path)
        .unwrap()
        .split(",")
        .filter(|x| !x.is_empty())
        .map(|x| {
            let y: String = x.split_whitespace().collect();
            return y.parse::<i32>().unwrap();
        })
        .collect::<Vec<i32>>();

    let maximum = *positions.iter().max().unwrap();

    let mut least = i32::MAX;
    let mut best_position = i32::MAX;

    for target in 0..maximum {
        let mut cost = 0;
        for position in &positions {
            cost += (target - position).abs()
        }
        if cost < least {
            least = cost;
            best_position = target;
        }
    }

    println!("part 1: best_position={:?} cost={:?}", best_position, least);

    least = i32::MAX;
    best_position = i32::MAX;

    for target in 0..maximum {
        let mut cost = 0;
        for position in &positions {
            let basic_cost = (target - position).abs();
            let true_cost: i32 = (1..=basic_cost).sum();
            cost += true_cost;
        }
        if cost < least {
            least = cost;
            best_position = target;
        }
    }

    println!("part 2: best_position={:?} cost={:?}", best_position, least);
}
