/*
   Extensions to the `ServiceHandler` class to handle tasks we need
   for testing that aren't the purpose of this example.

   Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
   SPDX-License-Identifier: Apache-2.0
*/

import Foundation
import AWSIAM
import AWSClientRuntime
import ClientRuntime
import SwiftUtilities

@testable import ServiceHandler

public extension ServiceHandler {

    /// Create a new IAM policy.
    ///
    /// - Parameters:
    ///   - name: The name of the new policy.
    ///   - policyDocument: The policy document to assign to the new policy
    ///
    /// - Returns: A `MyPolicyRecord` describing the new policy.
    ///
    func createPolicy(name: String, policyDocument: String) async throws -> MyPolicyRecord {
        let input = CreatePolicyInput(
            policyDocument: policyDocument,
            policyName: name
        )
        do {
            let output = try await client.createPolicy(input: input)
            guard let policy = output.policy else {
                throw ServiceHandlerError.noSuchPolicy
            }
            guard   let policyName = policy.policyName,
                    let policyID = policy.policyId,
                    let policyARN = policy.arn else {
                throw ServiceHandlerError.noSuchPolicy
            }
            return MyPolicyRecord(name: policyName, id: policyID, arn: policyARN)
        } catch {
            throw error
        }
    }

    /// Delete an IAM policy.
    ///
    /// - Parameter name: The `MyPolicyRecord` describing the policy to
    ///   delete.
    func deletePolicy(policy: MyPolicyRecord) async throws {
        let input = DeletePolicyInput(
            policyArn: policy.arn
        )
        do {
            _ = try await client.deletePolicy(input: input)
        } catch {
            throw error
        }
    }
}