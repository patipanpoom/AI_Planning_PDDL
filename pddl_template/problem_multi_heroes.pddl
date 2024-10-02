;It's recommended to install the misc-pddl-generators plugin 
;and then use Network generator to create the graph
(define (problem p3-dangeon)
  (:domain Dangeon)
  (:objects
            cell1_1 cell1_2 cell1_3 cell1_4 cell1_5 cell1_6
            cell2_1 cell2_2 cell2_3 cell2_4 cell2_5 cell2_6
            cell3_1 cell3_2 cell3_3 cell3_4 cell3_5 cell3_6
            cell4_1 
            - cells
            sword1 - swords
            hero1 hero2 hero3 - heroes
            key1 - keys
  )
  (:init
  
    ;Initial Hero Location
    (at-hero hero1 cell1_1)
    (at-hero hero2 cell2_1)
    (at-hero hero3 cell3_1)
    (current-turn hero1)
    (current-turn hero2)
    (current-turn hero3)
    
    ;He starts with a free arm
    (arm-free hero1)
    (arm-free hero2)
    (arm-free hero3)
    
    ;Initial location of the swords
    (at-sword sword1 cell2_3)

    ;Initial location of Monsters
    (has-monster cell2_4)
    (has-monster cell3_5)
    
    ;Initial location of Traps
    (has-trap cell1_4)

    ;Initial location of Keys
    (at-key key1 cell3_2)

    ;Initial location of Locked Room
    (is-locked cell1_5)
    (is-locked cell3_3)

    ;Initial location of Goals
    (at-goal hero1 cell1_6)
    (at-goal hero2 cell2_5)
    (at-goal hero3 cell3_6)

    ;Graph Connectivity
    (connected cell1_1 cell1_2)

    (connected cell1_2 cell1_1)
    (connected cell1_2 cell1_3)

    (connected cell1_3 cell1_2)
    (connected cell1_3 cell1_4)

    (connected cell1_4 cell1_3)
    (connected cell1_4 cell4_1)

    (connected cell1_5 cell1_6)
    (connected cell1_5 cell4_1)

    (connected cell2_1 cell2_2)

    (connected cell2_2 cell2_1)
    (connected cell2_2 cell2_3)

    (connected cell2_3 cell2_2)
    (connected cell2_3 cell2_4)
    
    (connected cell2_4 cell2_3)
    (connected cell2_4 cell4_1)

    (connected cell2_5 cell4_1)

    (connected cell3_1 cell3_2)

    (connected cell3_2 cell3_1)
    (connected cell3_2 cell3_3)

    (connected cell3_3 cell3_2)
    (connected cell3_3 cell3_4)

    (connected cell3_4 cell3_3)
    (connected cell3_4 cell4_1)

    (connected cell3_5 cell3_6)
    (connected cell3_5 cell4_1)

    (connected cell3_6 cell3_5)
    
    (connected cell4_1 cell1_4)
    (connected cell4_1 cell1_5)
    (connected cell4_1 cell2_4)
    (connected cell4_1 cell2_5)
    (connected cell4_1 cell3_4)
    (connected cell4_1 cell3_5)
  )
  (:goal (and
            ;Hero's Goal Location
            (at-hero hero1 cell1_6)
            (at-hero hero2 cell2_5)
            (at-hero hero3 cell3_6)
  ))
  
)
