//
//  ProtocolsForServices.swift
//  CHSURasp
//
//  Created by Владимир Иванов on 27.04.2025.
//

import Foundation

protocol NewsServiceProtocol {
    func getNews(page: Int, completion: @escaping (Result<News, APError>) -> Void)
}

protocol AuthorizationServiceProtocol {
    func authorize(completion: @escaping (Result<Token, APError>) -> Void)
    func validate(completion: @escaping (Result<String, APError>) -> Void)
}

protocol NetworkDateProtocol {
    func getWeekByDate(date: String, completion: @escaping (Result<String, APError>) -> Void)
}

protocol GetGroupsProtocol {
    func getGroups(completion: @escaping (Result<[Group], APError>) -> Void)
}

protocol GetTeachersProtocol {
    func getTeachers(completion: @escaping (Result<[Teacher], APError>) -> Void)
}

protocol GetScheduleForStudentProtocol {
    func getScheduleForStudents(from: String, to: String, groupId: Int, completion: @escaping (Result<[Schedule], APError>) -> Void)
}

protocol GetScheduleForTeacherProtocol {
    func getScheduleForTeachers(from: String, to: String, teacherId: Int, completion: @escaping (Result<[Schedule], APError>) -> Void)
}
