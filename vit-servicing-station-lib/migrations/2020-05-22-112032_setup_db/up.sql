create table funds
(
    id INTEGER NOT NULL
        primary key autoincrement,
    fund_name VARCHAR NOT NULL,
    fund_goal VARCHAR NOT NULL,
    registration_snapshot_time BIGINT NOT NULL,
    voting_power_threshold BIGINT NOT NULL,
    rewards_info VARCHAR NOT NULL,
    fund_start_time BIGINT NOT NULL,
    fund_end_time BIGINT NOT NULL,
    next_fund_start_time BIGINT NOT NULL
);

create table proposals
(
    id INTEGER NOT NULL
        primary key autoincrement,
    proposal_id VARCHAR NOT NULL,
    proposal_category VARCHAR NOT NULL,
    proposal_title VARCHAR NOT NULL,
    proposal_summary VARCHAR NOT NULL,
    proposal_public_key VARCHAR NOT NULL,
    proposal_funds BIGINT NOT NULL,
    proposal_url VARCHAR NOT NULL,
    proposal_files_url VARCHAR NOT NULL,
    proposal_impact_score BIGINT NOT NULL,
    proposer_name VARCHAR NOT NULL,
    proposer_contact VARCHAR NOT NULL,
    proposer_url VARCHAR NOT NULL,
    proposer_relevant_experience VARCHAR NOT NULL,
    chain_proposal_id BLOB NOT NULL,
    chain_proposal_index BIGINT NOT NULL,
    chain_vote_options VARCHAR NOT NULL,
    chain_voteplan_id VARCHAR NOT NULL,
    challenge_id INTEGER NOT NULL
);

create table proposal_simple_challenge (
    proposal_id VARCHAR NOT NULL primary key,
    proposal_solution VARCHAR
);

create table proposal_community_choice_challenge (
    proposal_id VARCHAR NOT NULL primary key,
    proposal_brief VARCHAR,
    proposal_importance VARCHAR,
    proposal_goal VARCHAR,
    proposal_metrics VARCHAR
);

create table voteplans
(
    id INTEGER NOT NULL
        primary key autoincrement,
    chain_voteplan_id VARCHAR NOT NULL
        unique,
    chain_vote_start_time BIGINT NOT NULL,
    chain_vote_end_time BIGINT NOT NULL,
    chain_committee_end_time BIGINT NOT NULL,
    chain_voteplan_payload VARCHAR NOT NULL,
    chain_vote_encryption_key VARCHAR NOT NULL,
    fund_id INTEGER NOT NULL
);

create table api_tokens
(
    token BLOB NOT NULL UNIQUE PRIMARY KEY ,
    creation_time BIGINT NOT NULL,
    expire_time BIGINT NOT NULL
);

create table challenges
(
    id INTEGER NOT NULL
        primary key autoincrement,
    challenge_type VARCHAR NOT NULL,
    title VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    rewards_total BIGINT NOT NULL,
    proposers_rewards BIGINT NOT NULL,
    fund_id INTEGER NOT NULL,
    challenge_url VARCHAR NOT NULL
);

CREATE VIEW full_proposals_info
AS
SELECT
    proposals.*,
    proposal_simple_challenge.proposal_solution,
    proposal_community_choice_challenge.proposal_brief,
    proposal_community_choice_challenge.proposal_importance,
    proposal_community_choice_challenge.proposal_goal,
    proposal_community_choice_challenge.proposal_metrics,
    voteplans.chain_vote_start_time,
    voteplans.chain_vote_end_time,
    voteplans.chain_committee_end_time,
    voteplans.chain_voteplan_payload,
    voteplans.chain_vote_encryption_key,
    voteplans.fund_id,
    challenges.challenge_type
FROM
    proposals
        INNER JOIN voteplans ON proposals.chain_voteplan_id = voteplans.chain_voteplan_id
        INNER JOIN challenges on challenges.id = proposals.challenge_id
        LEFT JOIN proposal_simple_challenge
            on proposals.proposal_id = proposal_simple_challenge.proposal_id
            and challenges.challenge_type = 'simple'
        LEFT JOIN proposal_community_choice_challenge
            on proposals.proposal_id = proposal_community_choice_challenge.proposal_id
            and challenges.challenge_type = 'community-choice'