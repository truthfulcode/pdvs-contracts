M1: authentication
    UC001: verify access token
        TC001_01: verify access token

        _01: correctly recover signer address
        _02: invalid signature
        _03: invalid userType
        _04: recovered address associated with valid userType

    UC002: login
        TC002_01: verify access token

        _01: connect as an admin
        _02: connect as a CM
        _03: connect as a student
        _04: connect as an unregistered user

M2: manage users
    UC003: add users
        TC003_01: add user (address)
            _02: not including 20 hexadecimal value
            _03: valid checksumed input address
            _04: non-checksumed input address
            _05: empty input
            _06: input doesn't start with 0x
        TC003_02: add user (matric number)
            _01: includes mix of number and letters
            _02: includes only numbers
            _03: includes only letters
            _04: includes other characters
            _05: empty input
        TC003_03: add user (voting power)
            _01: number is between 0.01 and 4.00
            _02: input is not a number
            _03: input is a number beyond 4
            _04: input is less than 0
            _05: input has more than 2 decimal precision
            _06: empty input
        TC003_04: add user (user type)
            _01: input is STUDENT
            _02: input is COMMITTEE_MEMBER
            _03: input is another value
            _04: empty input
    UC004: remove users
        TC004_01: remove user
            _01: user not deleted yet
            _02: user already deleted

M3: manage proposals
    UC005: search proposals
        TC005_01: search proposals

        _01: input has an matching results of title or description 
        _02: input has an unmatching result
    UC006: edit proposals
        _01: edit title:
            TC006_01: edit proposal title

            _01: input title that at least include 5 words
            _02: input title includes characters (:;?`"'#%@~$^&*()-_=/\.,)
            _03: input title that includes other characters (<>)
            _04: input title that includes only numbers
            _05: empty title input
        _02: edit description:
            TC006_02: edit proposal description

            _01: input description that at least include 120 characters
            _02: input description that includes only numbers
            _03: empty description input
    UC007: propose proposals
        _01: propose proposal (title)
            TC007_01: propose proposal (title)
        
            _01: input title that at least include 5 words
            _02: input title includes characters (:;?`"'#%@~$^&*()-_=/\.,)
            _03: input title that includes other characters (<>)
            _04: input title that includes only numbers
            _05: empty title input

        _02: propose proposal (description)
            TC007_02: propose proposal (description)

            _01: input description that at least include 120 characters
            _02: input description that includes only numbers
            _03: empty description input
    UC008: like proposals
        _01: clicking like proposal
            TC008_01: clicking proposal like button

            _01: unlit like button 
            _02: lit like button        
    UC009: manage proposals
        _01: create
            TC009_01: create proposal

            _01: create proposal (title)
                TC009_01_01: create proposal (title)

                _01: input title that at least include 5 words
                _02: input title includes characters (:;?`"'#%@~$^&*()-_=/\.,)
                _03: input title that includes other characters (<>)
                _04: input title that includes only numbers
                _05: empty title input
            _02: create proposal (description)
                TC009_01_02: create proposal (description)

                _01: input description that at least include 120 characters
                _02: input description that includes only numbers
                _03: empty description input

        _02: approve
            TC009_02: approve proposal
            _01: click approve button when proposal is in a pending state
        _03: reject
            TC009_03: reject proposal
            _01: click reject button when proposal is in a pending state
        _04: publish
            TC009_04: publish proposal
            _01: click publish button when proposal is in an approved state

M4: Manage Replies
    UC010: Manage Reply on Proposals
        _01: reply
            TC010_01: post a reply
            _01: reply to another reply already deleted
            _02: reply to another reply not deleted yet
            _03: empty reply message
            _04: reply message is shorter than 5 characters
        _02: edit reply
            TC010_02: edit reply
            _01: edit a reply that was created less than 10 minutes ago
            _02: edit a reply that was created more than 10 minutes ago
    UC011: Delete Replies
        _01: delete reply
            TC011_01: delete reply
            _01: reply not deleted yet
            _02: reply already deleted

M5: Voting Platform
    U0C12: Vote on Proposals
        TC012_01: vote on a proposal
        _01: vote on proposal for first time
        _02: vote on proposal for second time
        _03: include a comment along with vote
        _04: don't include a comment along with vote




TC001_01
TC002_01
TC003_01
TC003_02
TC003_03
TC003_04
TC004_01
TC005_01
TC006_01
TC006_02
TC007_01
TC007_02
TC008_01
TC009_01
TC009_02
TC009_03
TC009_04
TC010_01
TC011_01
TC012_01