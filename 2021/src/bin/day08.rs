mod util;

use std::collections::HashSet;

fn part1(input: &Vec<&str>) {
    let output = &input
        .iter()
        .skip(1)
        .step_by(2)
        .map(|x| {
            x.split(" ")
                .map(|x| util::remove_whitespace(x))
                .filter(|x| !x.is_empty())
                .collect::<Vec<String>>()
        })
        .flatten()
        .collect::<Vec<String>>();

    let answer = output
        .iter()
        .filter(|x| vec![2, 3, 4, 7].contains(&x.len()))
        .count();

    println!("part 1: {:?}", answer);
}

fn to_hash_set(s: &str) -> HashSet<char> {
    let mut o = HashSet::new();
    for c in s.chars() {
        o.insert(c);
    }
    return o;
}

fn derive_numbers(input: Vec<&str>) -> Vec<HashSet<char>> {
    let mut set_numbers = vec![false; 10];
    let mut output = vec![HashSet::new(); 10];

    // Being lazy here:
    // first pass just to set 1, 4. 7, 8
    for item in &input {
        let idx = match item.len() {
            2 => Some(1),
            3 => Some(7),
            4 => Some(4),
            7 => Some(8),
            _ => None,
        };
        if idx.is_some() {
            let i = idx.unwrap();
            if !set_numbers[i] {
                output[i] = to_hash_set(item);
                set_numbers[i] = true;
            }
            continue;
        }
    }

    // Then being lazy again
    // looping until we get all the numbers set since we dont know the order
    loop {
        // exit if we can
        let set = set_numbers.iter().filter(|&x| *x == true).count();
        if set == 10 {
            break;
        }

        for item in &input {
            let potential = to_hash_set(item);

            // 2, 3, 5 all use 5 points
            if item.len() == 5 {
                // 7 and 3 will overlap complete
                // but 2 and 5 wont
                if !set_numbers[3] {
                    if output[7].intersection(&potential).count() == 3 {
                        output[3] = potential.clone();
                        set_numbers[3] = true;
                        continue;
                    }
                }

                // two and four have 2 intersection
                if !set_numbers[2] {
                    if output[4].intersection(&potential).count() == 2 {
                        output[2] = potential.clone();
                        set_numbers[2] = true;
                        continue;
                    }
                }

                // lastly we know its five
                // though we could also know
                // because it has 3 intersections
                // with four
                if !set_numbers[5] {
                    output[5] = potential.clone();
                    set_numbers[5] = true;
                    continue;
                }
            }

            // 0, 6, 9 all use 6 points
            if item.len() == 6 {
                if !set_numbers[0] {
                    // all of 7 and part of 4 to distinguish from 6 amd 9
                    if output[7].intersection(&potential).count() == 3
                        && output[4].intersection(&potential).count() == 3
                    {
                        output[0] = potential.clone();
                        set_numbers[0] = true;
                        continue;
                    }
                }

                // six and one only overlap
                // once but twice for the others
                if !set_numbers[6] {
                    if output[1].intersection(&potential).count() == 1 {
                        output[6] = potential.clone();
                        set_numbers[6] = true;
                        continue;
                    }
                }

                if !set_numbers[9] {
                    if output[7].intersection(&potential).count() == 3
                        && output[4].intersection(&potential).count() == 4 {

                        output[9] = potential.clone();
                        set_numbers[9] = true;
                        continue;
                    }
                }
            }
        }
    }

    return output;
}

fn part2(input: &Vec<&str>) {
    // Get a list of all the hash sets for each number
    let answers = input
        .iter()
        .step_by(2)
        .filter(|x| !x.is_empty())
        .map(|x| x.split(" ").collect::<Vec<&str>>())
        .map(|x| derive_numbers(x))
        .collect::<Vec<_>>();

    // These are the codes we need to decipher
    let number_lines = input
        .iter()
        .skip(1)
        .step_by(2)
        .filter(|x| !x.is_empty())
        .map(|x| x.split(" ").collect::<Vec<&str>>())
        .collect::<Vec<_>>();

    let mut total = 0;

    // For each input line
    for (i, line) in number_lines.iter().enumerate() {

        // String builder
        let mut sub_total = String::new();

        // For each digit encoded
        for item in line {

            // Create a new hash
            let set = to_hash_set(item);

            for (j, ans) in answers[i].iter().enumerate() {
                if &set == ans {
                    // If the hash matches a known digit, return it a string
                    // the string builder
                    sub_total.push_str(j.to_string().as_str());
                }
            }
        }
        // Parse the string and add it to our total
        total += sub_total.parse::<i32>().unwrap();
    }

    println!("part 2: {}", total);
}

fn main() {
    let path = "input/day08.txt";
    let raw = util::load_file_split(path).unwrap();

    let input = raw
        .iter()
        .map(|x| x.split(" | "))
        .flatten()
        .collect::<Vec<&str>>();

    part1(&input);
    part2(&input);
}
