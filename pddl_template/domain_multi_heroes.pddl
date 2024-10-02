(define (domain Dangeon)

    (:requirements
        :typing
        :negative-preconditions
    )

    (:types
        heroes keys swords cells
    )

    (:predicates
        ;Hero's cell location
        (at-hero ?h - heroes ?loc - cells)
        
        ;Hero's turn
        (current-turn ?h - heroes)

        ;Sword cell location
        (at-sword ?s - swords ?loc - cells)
        
        ;Goal's cell location
        (at-goal ?h - heroes ?loc - cells)

        ;Key cell location
        (at-key ?k - keys ?loc - cells)

        ;Indicates if a cell location has a monster
        (has-monster ?loc - cells)
        
        ;Indicates if a cell location has a trap
        (has-trap ?loc - cells)
        
        ;Indicates if a cell, sword and key has been destroyed
        (is-destroyed ?obj)
        
        ;Indicates if a cell is locked
        (is-locked ?loc - cells)

        ;connects cells
        (connected ?from ?to - cells)
        
        ;Hero's hand is free
        (arm-free ?h - heroes)
        
        ;Hero's holding a sword
        (holding-sword ?h - heroes ?s - swords)
        
        ;Hero's holding a key
        (holding-key ?h - heroes ?k - keys)
    )

    (:action next-round
        :precondition (and 
                            (forall (?x - heroes) 
                                (not (current-turn ?x))
                            )                      
        )
        :effect (and 
                            (forall (?y - heroes) 
                                (when 
                                    (not (current-turn ?y))
                                    (current-turn ?y)
                                )
                            )  
                )
    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed
    ;Effects move the hero, and destroy the original cell. No need to destroy the sword.
    (:action move
        :parameters (?h - heroes ?from ?to - cells)
        :precondition (and 
                            (current-turn ?h)
                            (at-hero ?h ?from)
                            (not (at-goal ?h ?from))
                            (connected ?from ?to)
                            (not (has-trap ?from))
                            (not (has-trap ?to))
                            (not (has-monster ?to))
                            (not (is-destroyed ?to))     
                            (not (is-locked ?to))                   
        )               
        :effect (and 
                            (at-hero ?h ?to)
                            (not (at-hero ?h ?from))
                            (is-destroyed ?from)
                            (forall (?other_h - heroes)
                                (when
                                    (and
                                        (not (= ?other_h ?h))
                                        (at-hero ?other_h ?from)
                                    )
                                    (not (is-destroyed ?from))
                                )
                            )
                            (not (current-turn ?h))
                )
    )

    ;When this action is executed, the hero gets into a location with a trap
    (:action move-to-trap
        :parameters (?h - heroes ?from ?to - cells)
        :precondition (and 
                            (current-turn ?h)
                            (at-hero ?h ?from)
                            (not (at-goal ?h ?from))
                            (connected ?from ?to)
                            (not (is-destroyed ?to))
                            (not (has-trap ?from))
                            (has-trap ?to)
                            (arm-free ?h) 
        )
        :effect (and 
                            (at-hero ?h ?to)
                            (not (at-hero ?h ?from))
                            (is-destroyed ?from)
                            (forall (?other_h - heroes)
                                (when
                                    (and
                                        (not (= ?other_h ?h))
                                        (at-hero ?other_h ?from)
                                    )
                                    (not (is-destroyed ?from))
                                )
                            )
                            (not (current-turn ?h))
                )
    )

    ;When this action is executed, the hero gets into a location with locked room
    (:action move-to-locked
        :parameters (?h - heroes ?from ?to - cells ?k - keys)
        :precondition (and 
                            (current-turn ?h)
                            (at-hero ?h ?from)
                            (not (at-goal ?h ?from))
                            (connected ?from ?to)
                            (not (is-destroyed ?to))
                            (not (has-trap ?from))
                            (holding-key ?h ?k)
                            (is-locked ?to)
        )
        :effect (and 
                            (at-hero ?h ?to)
                            (not (at-hero ?h ?from))
                            (is-destroyed ?from)
                            (forall (?other_h - heroes)
                                (when
                                    (and
                                        (not (= ?other_h ?h))
                                        (at-hero ?other_h ?from)
                                    )
                                    (not (is-destroyed ?from))
                                )
                            )
                            (not (current-turn ?h))
                )
    )

    ;When this action is executed, the hero gets into a location with a monster
    (:action move-to-monster
        :parameters (?h - heroes ?from ?to - cells ?s - swords)
        :precondition (and 
                            (current-turn ?h)
                            (at-hero ?h ?from)
                            (not (at-goal ?h ?from))
                            (connected ?from ?to)
                            (not (is-destroyed ?to))
                            (not (has-trap ?from))
                            (has-monster ?to)
                            (holding-sword ?h ?s)
        )
        :effect (and 
                            (at-hero ?h ?to)
                            (not (at-hero ?h ?from))
                            (is-destroyed ?from)
                            (forall (?other_h - heroes)
                                (when
                                    (and
                                        (not (= ?other_h ?h))
                                        (at-hero ?other_h ?from)
                                    )
                                    (not (is-destroyed ?from))
                                )
                            )
                            (not (current-turn ?h))
                )
    )
    
    ;Hero picks a sword if he's in the same location
    (:action pick-sword
        :parameters (?h - heroes ?loc - cells ?s - swords)
        :precondition (and 
                            (current-turn ?h)
                            (at-sword ?s ?loc)
                            (at-hero ?h ?loc)
                            (not (at-goal ?h ?loc))
                            (arm-free ?h)
                      )
        :effect (and
                            (holding-sword ?h ?s)
                            (not (arm-free ?h))
                            (not (at-sword ?s ?loc))
                            (not (current-turn ?h))
                )
    )
    
    ;Hero destroys his sword. 
    (:action destroy-sword
        :parameters (?h - heroes ?loc - cells ?s - swords)
        :precondition (and 
                            (current-turn ?h)
                            (holding-sword ?h ?s)
                            (at-hero ?h ?loc)
                            (not (at-goal ?h ?loc))
                            (not (has-monster ?loc))
                            (not (has-trap ?loc))
                      )
        :effect (and
                            (not (holding-sword ?h ?s))
                            (arm-free ?h)
                            (is-destroyed ?s)
                            (not (current-turn ?h))
                )
    )
    ;Hero picks a key if he's in the same location
    (:action pick-key
        :parameters (?h - heroes ?k - keys ?loc - cells)
        :precondition (and 
                            (current-turn ?h)
                            (at-key ?k ?loc)
                            (at-hero ?h ?loc)
                            (not (at-goal ?h ?loc))
                            (arm-free ?h)
                      )
        :effect (and
                            (holding-key ?h ?k)
                            (not (arm-free ?h))
                            (not (at-key ?k ?loc))
                            (not (current-turn ?h))
                )
    )
    
    ;Hero destroys his key. 
    (:action destroy-key
        :parameters (?h - heroes ?k - keys ?loc - cells)
        :precondition (and 
                            (current-turn ?h)
                            (holding-key ?h ?k)
                            (at-hero ?h ?loc)
                            (not (at-goal ?h ?loc))
                            (not (has-monster ?loc))
                            (not (has-trap ?loc))
                      )
        :effect (and
                            (not (holding-key ?h ?k))
                            (arm-free ?h)
                            (is-destroyed ?k)
                            (not (current-turn ?h))
                )
    )

    ;Hero disarms the trap with his free arm
    (:action disarm-trap
        :parameters (?h - heroes ?loc - cells)
        :precondition (and 
                            (current-turn ?h)
                            (at-hero ?h ?loc)
                            (not (at-goal ?h ?loc))
                            (has-trap ?loc)
                            (arm-free ?h)
                      )
        :effect (and
                            (not (has-trap ?loc))
                            (not (current-turn ?h))
                )
    )
    
    ;Hero give key to other hero
    (:action give-key
        :parameters (?giver ?receiver - heroes ?loc - cells ?k - keys)
        :precondition (and 
                            (current-turn ?giver)
                            (not (has-trap ?loc))
                            (not (has-monster ?loc))
                            (at-hero ?giver ?loc)
                            (not (at-goal ?giver ?loc))
                            (at-hero ?receiver ?loc)
                            (holding-key ?giver ?k)
                            (arm-free ?receiver)
        )
        :effect (and
                            (not (current-turn ?giver))
                            (holding-key ?receiver ?k)
                            (not (arm-free ?receiver))
                            (not (holding-key ?giver ?k))
                            (arm-free ?giver)
        )
    )

    ;Hero give sword to other hero
    (:action give-sword
        :parameters (?giver ?receiver - heroes ?loc - cells ?s - swords)
        :precondition (and 
                            (current-turn ?giver)
                            (not (has-trap ?loc))
                            (not (has-monster ?loc))
                            (at-hero ?giver ?loc)
                            (not (at-goal ?giver ?loc))
                            (at-hero ?receiver ?loc)
                            (holding-sword ?giver ?s)
                            (arm-free ?receiver)
        )
        :effect (and
                            (not (current-turn ?giver))
                            (holding-sword ?receiver ?s)
                            (not (arm-free ?receiver))
                            (not (holding-sword ?giver ?s))
                            (arm-free ?giver)
        )
    )
)