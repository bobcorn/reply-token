// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface IStudentsRegistry {
    function isStudent(address studentAddress) external view returns (bool);
}
