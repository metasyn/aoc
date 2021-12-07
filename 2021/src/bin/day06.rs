mod util;

use std::collections::VecDeque;

fn tick(school: &mut Vec<u64>) {
    let mut guppies = 0;

    school.iter_mut()
        .for_each(|x| {
            if *x == 0 {
                *x = 6;
                guppies += 1;
            } else {
                *x -= 1;
            }
        });

    school.extend(vec![8; guppies]);
}

fn school_to_days(school: Vec<u64>) -> VecDeque<u64> {
    let mut output = VecDeque::from(vec![0; 9]);
    for idx in school {
        output[idx as usize] += 1
    }
    return output;
}

fn track(days: &mut VecDeque<u64>) {
    let sixes = days.pop_front().unwrap();
    days[6] = days[6] + sixes;
    days.push_back(sixes);
}

fn main() {
    let path = "input/day06.txt";
    let school = util::load_file(path)
        .unwrap()
        .split(",")
        .filter(|x| !x.is_empty())
        .map(|x| {
            let no_white: String = x.split_whitespace().collect();
            return no_white.parse::<u64>().unwrap()
        })
        .collect::<Vec<u64>>();

    let mut days = school_to_days(school);
    println!("{:?}", days);
    for _ in 0..256 {
        // Way too slow for the bigger case
        // tick(&mut school);
        track(&mut days);
    }
    println!("{:?}", days.iter().sum::<u64>());

}
