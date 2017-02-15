#!/usr/bin/env bats

mkdir -p 'project1/.docksal'
mkdir -p 'project2/.docksal'

# create project name conflict
mkdir -p 'duplicate/project1/.docksal'

ls

# create VIRTUAL_HOST conflict
echo 'VIRTUAL_HOST=project1.docksal' > 'project2/.docksal/docksal.env'

@test "Start project1" {
	cd 'project1'
	fin start
	run fin projects
	echo "$output" | grep 'project1'
}

@test "Try starting project1 duplicate" {
	pwd
	echo $output
	cd '../duplicate/project1'
	run fin start
	[ ! $status -eq 0 ]
}

@test "Try starting project1 VIRTUAL_HOST conflict" {
	cd '../../project2'
	run fin start
	[ ! $status -eq 0 ]
}
