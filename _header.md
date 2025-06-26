# Azure Event Hub Terraform Module

This Terraform module provisions and manages a fully configurable Azure Event Hubs environment. It supports deploying an Event Hub Namespace, Event Hubs, authorization rules, consumer groups, disaster recovery configuration, customer-managed keys (CMKs), schema groups, and optional integration with a dedicated Event Hubs cluster. The module enables advanced features like capture configuration, network rules, managed identities, and encryption—all using flexible input variables.


# Features

	- Creates an Event Hub Namespace with support for auto-inflate, capacity, and identity configuration.
	- Supports optional dedicated Event Hub Clusters with configurable SKU and location.
	- Creates one or more Event Hubs with optional capture settings (blob storage integration).
	- Supports Managed Identity for Event Hub Namespace.
	- Adds Network Rulesets including IP and VNet filtering.
	- Configures Authorization Rules at both Event Hub and Namespace levels.
	- Creates Consumer Groups within Event Hubs.
	- Enables Schema Group creation for data validation and compatibility checks.
	- Integrates Customer-Managed Keys (CMKs) using Key Vault and identity.
	- Sets up Geo-Disaster Recovery Configuration with a partner namespace.
	- Allows definition of resource timeouts for all supported components.

# Example Usage

This example demonstrates how to provision a fully configured Azure Event Hub environment, including an Event Hub Namespace, one or more Event Hubs with capture settings, authorization rules, a consumer group, schema group, disaster recovery setup, and optional dedicated cluster integration. It showcases how to customize identity, networking, encryption, and timeouts using flexible module inputs.