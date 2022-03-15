// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Voting {

  address owner;
    
  struct Candidate {
    string name;
    uint256 votes;
    bool confirmed;
  }

  event VoteSubmitted (
    string candidateName,
    uint votes,
    bool confirmed
  );

  event CandidateProposed (
    string candidateName,
    uint votes,
    bool confirmed
  );

  event ConfirmedCandidate (
    string candidateName
  );

  Candidate[] public candidates;

  string[] public unconfirmedCandidates;

  mapping (address => bool) voteTracker;

  constructor() {
      owner = msg.sender;
  }

  function isOwner() public view returns (bool) {
      if (msg.sender == owner) {
        return true;
      }
      return false;
  }

  function getOwner() public view returns (address) {
    return owner;
  }

  function getCandidates() public view returns (Candidate[] memory) {
    return candidates;
  }
  
  function proposeCandidate(string memory _name) public {
    if (isOwner()) {
        candidates.push(Candidate(_name, 0, true));
        emit CandidateProposed(_name, 0, true);
    } else {
        candidates.push(Candidate(_name, 0, false));
        emit CandidateProposed(_name, 0, false);
    }
  }

  function confirmCandidate(string memory name) public {
    // make sure it's the owner calling here
    require(isOwner(), "You are not the owner. You can't confirm a candidate. Do not pass go, do not collect $200");
    // loop through candidates
    for (uint i = 0; i < candidates.length; i++) {
        // check to see that the current candidate name matches the param passed in
        if (keccak256(abi.encodePacked((candidates[i].name))) == keccak256(abi.encodePacked(name)) && !candidates[i].confirmed) {
            // if so, update the candidate to be confirmed
            candidates[i].confirmed = true;
            // TODO: emit an event when candidate is confirmed
            emit ConfirmedCandidate(name);
        }
    }   
  }

  function vote(string memory name) public {
      // check to make sure this person hasn't voted
    // require(!voteTracker[msg.sender], "Sorry bruv, you've voted already");

    // loop through the candidates list
    for (uint i = 0; i < candidates.length; i++) {
        // compare the name passed in as a param to the name of the candidate
        // also check to make sure the candidate they're voting for is confirmmed
        if (keccak256(abi.encodePacked((candidates[i].name))) == keccak256(abi.encodePacked(name))) {
            // when it matches, increment the votes on that candidate
            candidates[i].votes++;
            // update the mapping to say that this person has voted
            voteTracker[msg.sender] = true;
            // TODO: emit event saying that vote has been cast
            emit VoteSubmitted(name, candidates[i].votes, true);
        }
    }
  }
}