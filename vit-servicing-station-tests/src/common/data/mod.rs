use vit_servicing_station_lib::db::models::{
    api_tokens::ApiTokenData, challenges::Challenge, funds::Fund, proposals::FullProposalInfo,
    voteplans::Voteplan,
};

mod csv_converter;
mod generator;
pub use csv_converter::CsvConverter;
pub use generator::{
    parse_challenges, parse_funds, parse_proposals, ArbitraryGenerator,
    ArbitraryValidVotingTemplateGenerator, ChallengeTemplate, ExternalValidVotingTemplateGenerator,
    FundTemplate, ProposalTemplate, Snapshot, TemplateLoadError, ValidVotePlanGenerator,
    ValidVotePlanParameters, ValidVotingTemplateGenerator,
};

pub fn token() -> (String, ApiTokenData) {
    ArbitraryGenerator::new().token()
}

pub fn token_hash() -> String {
    token().0
}

pub fn proposals() -> Vec<FullProposalInfo> {
    let mut gen = ArbitraryGenerator::new();
    let funds = gen.funds();
    gen.proposals(&funds)
}

pub fn funds() -> Vec<Fund> {
    ArbitraryGenerator::new().funds()
}

pub fn voteplans() -> Vec<Voteplan> {
    let mut gen = ArbitraryGenerator::new();
    let funds = gen.funds();
    gen.voteplans(&funds)
}

pub fn challenges() -> Vec<Challenge> {
    let mut gen = ArbitraryGenerator::new();
    let funds = gen.funds();
    gen.challenges(&funds)
}
